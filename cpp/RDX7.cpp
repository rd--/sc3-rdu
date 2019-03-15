/* https://github.com/asb2m10/dexed */

#include <math.h>
#include <stdint.h>

#include <SC_PlugIn.h>

#include "rdu.h"

#include "dx7/aligned_buf.h"
#include "dx7/controllers.h"
#include "dx7/dx7note.cc"
#include "dx7/env.cc"
#include "dx7/exp2.cc"
#include "dx7/fm_core.cc"
#include "dx7/fm_op_kernel.cc"
#include "dx7/freqlut.cc"
#include "dx7/lfo.cc"
#include "dx7/pitchenv.cc"
#include "dx7/sin.cc"

#include "dx7/EngineMkI.cpp"

#include "c-common/cfile.c"
#include "c-common/clip.c"
#include "c-common/dx7.c"
#include "c-common/float.h"
#include "c-common/memory.c"
#include "c-common/print.h"
#include "c-common/vector.c"

/* DEXED adds switches for each OP, this set them, 0x3F turns everything on */
void unpack_op_switch(Controllers *c,uint8_t x) {
    c->opSwitch[5] = ((x >> 5) &1) + 48;
    c->opSwitch[4] = ((x >> 4) &1) + 48;
    c->opSwitch[3] = ((x >> 3) &1) + 48;
    c->opSwitch[2] = ((x >> 2) &1) + 48;
    c->opSwitch[1] = ((x >> 1) &1) + 48;
    c->opSwitch[0] = ((x >> 0) &1) + 48;
}

void ctl_init(Controllers *c)
{
    c->values_[kControllerPitch] = 0x2000;
    c->values_[kControllerPitchRange] = 3;
    c->values_[kControllerPitchStep] = 0;
    c->modwheel_cc = 0;
    c->foot_cc = 0;
    c->breath_cc = 0;
    c->aftertouch_cc = 0;
    c->masterTune = 0;
    c->refresh();
    c->core = new EngineMkI; /* ALLOC - FmCore */
    unpack_op_switch(c,0x3F);
}

#define buf_zero(b,n) for(int _i = 0; _i < n; _i++) {b.get()[_i] = 0;}

/* SC3 */
static InterfaceTable *ft;

struct RDX7 : public Unit
{
    Controllers m_controllers;
    Lfo m_lfo;
    Dx7Note *m_dx7_note;
    uint8_t m_dx7_data[155];
    float m_prev_key_tr;
    float m_prev_data_tr;
    bool m_offline;
    rdu_declare_buf(data);
};

rdu_prototypes_dtor(RDX7);

void RDX7_Ctor(RDX7 *unit)
{
    Freqlut::init(SAMPLERATE);
    Exp2::init();
    Tanh::init();
    Sin::init();
    Lfo::init(SAMPLERATE);
    PitchEnv::init(SAMPLERATE);
    Env::init_sr(SAMPLERATE);
    ctl_init(&(unit->m_controllers));
    unit->m_dx7_note = new Dx7Note; /* NON-RT, SHOULD OVERRIDE CONSTRUCTOR */
    unit->m_prev_key_tr = 0;
    unit->m_prev_data_tr = 0;
    memcpy(unit->m_dx7_data,dx7_init_voice,155);
    unit->m_offline = true;
    rdu_init_buf(data);
    SETCALC(RDX7_next);
    RDX7_next(unit, 1);
}

/* N = 64 ; REQUIRES inNumSamples by a multiple of N */
void RDX7_next(RDX7 *unit,int inNumSamples)
{
    float *out = OUT(0);
    rdu_get_buf(data,0); /* INPUT 0 = VOICE-DATA BUFFER */
    rdu_check_buf(data,1);
    float key_tr = IN0(1); /* INPUT 1 = KEY GATE */
    float data_tr = IN0(2); /* INPUT 2 = DATA TRIGGER */
    int vc = (int)(IN0(3)); /* INPUT 3 = VOICE INDEX */
    int mnn = (int)(IN0(4)); /* INPUT 4 = MIDI NOTE NUMBER */
    int vel = (int)(IN0(5)); /* INPUT 5 = NOTE VELOCITY */
    if (data_tr > 0.0 && unit->m_prev_data_tr <= 0.0) {
        for(int i = 0; i < 155; i++) {
            unit->m_dx7_data[i] = (uint8_t)(unit->m_buf_data->data[(vc * 155) + i]);
        }
        unit->m_lfo.reset(unit->m_dx7_data + 137);
    }
    if (key_tr > 0.0 && unit->m_prev_key_tr <= 0.0) {
        unit->m_offline = false;
        for(int i = 0; i < 155; i++) {
            unit->m_dx7_data[i] = (uint8_t)(unit->m_buf_data->data[(vc * 155) + i]);
        }
        unit->m_lfo.keydown();
        unit->m_dx7_note->init(unit->m_dx7_data, mnn + (int)(unit->m_dx7_data[144]) - 24, vel);
        if (unit->m_dx7_data[136]) {
            unit->m_dx7_note->oscSync();
        }
    } else if (key_tr <= 0.0 && unit->m_prev_key_tr > 0.0) {
        unit->m_dx7_note->keyup();
    }
    if(unit->m_offline) {
        for (int i = 0; i < inNumSamples; i ++) {
            out[i] = 0.0;
        }
        return;
    }
    for (int i = 0; i < inNumSamples; i += N) {
        dprintf("RDX7: SUBFRAME: i=%d\n",i);
        int32_t lfovalue = unit->m_lfo.getsample();
        int32_t lfodelay = unit->m_lfo.getdelay();
        AlignedBuf<int32_t, N> audiobuf;
        buf_zero(audiobuf,N);
        unit->m_dx7_note->compute(audiobuf.get(), lfovalue, lfodelay, &(unit->m_controllers));
        for (int j = 0; j < N; j++) {
            int32_t val = audiobuf.get()[j];
            val = val >> 4;
            int clip_val = val < -(1 << 24) ? 0x8000 : val >= (1 << 24) ? 0x7fff : val >> 9;
            f32 f = clipf32 ((f32)clip_val / (f32)0x8000,-1,1);
            out[i + j] = f;
            audiobuf.get()[j] = 0;
        }
    }
    unit->m_prev_key_tr = key_tr;
    unit->m_prev_data_tr = data_tr;
}

void RDX7_Dtor(RDX7 *unit)
{
    delete unit->m_dx7_note;
}

rdu_load_dtor(RDX7);
