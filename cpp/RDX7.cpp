/* https://github.com/asb2m10/dexed */

#include <math.h>

#include <SC_PlugIn.h>

#include "rdu.h"

#include "dx7/aligned_buf.h"
#include "dx7/controllers.h"
#include "dx7/dx7note.cc"
#include "dx7/dx7note.h"
#include "dx7/env.cc"
#include "dx7/env.h"
#include "dx7/exp2.cc"
#include "dx7/exp2.h"
#include "dx7/fm_core.cc"
#include "dx7/fm_core.h"
#include "dx7/fm_op_kernel.cc"
#include "dx7/fm_op_kernel.h"
#include "dx7/freqlut.cc"
#include "dx7/freqlut.h"
#include "dx7/lfo.cc"
#include "dx7/lfo.h"
#include "dx7/pitchenv.cc"
#include "dx7/pitchenv.h"
#include "dx7/sin.cc"
#include "dx7/sin.h"
#include "dx7/synth.h"

/* SC3 */
static InterfaceTable *ft;

uint8_t dx7_data_init[155] = {
  95, 29, 20, 50, 99, 95, 0, 0, 41, 0, 19, 0, 115, 24, 79, 2, 0,
  95, 20, 20, 50, 99, 95, 0, 0, 0, 0, 0, 0, 3, 0, 99, 2, 0,
  95, 29, 20, 50, 99, 95, 0, 0, 0, 0, 0, 0, 59, 24, 89, 2, 0,
  95, 20, 20, 50, 99, 95, 0, 0, 0, 0, 0, 0, 59, 8, 99, 2, 0,
  95, 50, 35, 78, 99, 75, 0, 0, 0, 0, 0, 0, 59, 28, 58, 28, 0,
  96, 25, 25, 67, 99, 75, 0, 0, 0, 0, 0, 0, 83, 8, 99, 2, 0,
  94, 67, 95, 60, 50, 50, 50, 50, 4, 6, 34, 33, 0, 0, 56, 24,
  69, 46, 80, 73, 65, 78, 79, 32, 49, 32
};


struct RDX7 : public Unit
{
    Controllers m_controllers;
    Lfo m_lfo;
    Dx7Note *m_dx7_note;
    uint8_t m_dx7_data[161];
    float m_prev_tr;
    rdu_declare_buf(data);
};

rdu_prototypes_dtor(RDX7);

void RDX7_Ctor(RDX7 *unit)
{
    Exp2::init();
    Tanh::init();
    Sin::init();
    Freqlut::init(SAMPLERATE);
    Lfo::init(SAMPLERATE);
    PitchEnv::init(SAMPLERATE);
    Env::init_sr(SAMPLERATE);
    unit->m_controllers.values_[kControllerPitch] = 0x2000;
    unit->m_controllers.values_[kControllerPitchRange] = 3;
    unit->m_controllers.values_[kControllerPitchStep] = 0;
    unit->m_controllers.modwheel_cc = 0;
    unit->m_controllers.foot_cc = 0;
    unit->m_controllers.breath_cc = 0;
    unit->m_controllers.aftertouch_cc = 0;
    unit->m_controllers.masterTune = 0;
    unit->m_controllers.refresh();
    unit->m_dx7_note = new Dx7Note; /* NON-RT */
    unit->m_prev_tr = 0;
    memcpy(unit->m_dx7_data,dx7_data_init,155);
    unit->m_dx7_note->init(unit->m_dx7_data, 60, 60); /* DEFAULT */
    rdu_init_buf(data);
    SETCALC(RDX7_next);
    RDX7_next(unit, 1);
}

void unpack_op_switch(Controllers *controllers,uint8_t packOpValue) {
    controllers->opSwitch[5] = ((packOpValue >> 5) &1) + 48;
    controllers->opSwitch[4] = ((packOpValue >> 4) &1) + 48;
    controllers->opSwitch[3] = ((packOpValue >> 3) &1) + 48;
    controllers->opSwitch[2] = ((packOpValue >> 2) &1) + 48;
    controllers->opSwitch[1] = ((packOpValue >> 1) &1) + 48;
    controllers->opSwitch[0] = (packOpValue &1) + 48;
}

/* N = 64 ; REQUIRES inNumSamples by a multiple of N */
void RDX7_next(RDX7 *unit,int inNumSamples)
{
    float *out = OUT(0);
    rdu_get_buf(data,0); /* INPUT 0 = VOICE-DATA BUFFER */
    rdu_check_buf(data,1);
    for(int i = 0; i < 155; i++) {
        unit->m_dx7_data[i] = (uint8_t)(unit->m_buf_data->data[i]);
    }
    unpack_op_switch(&(unit->m_controllers),0x3F);
    unit->m_lfo.reset(unit->m_dx7_data + 137);
    float tr = IN0(1); /* INPUT 1 = GATE */
    int mnn = (int)(IN0(2)) + (int)(unit->m_dx7_data[144]) - 24; /* INPUT 2 = MIDI NOTE NUMBER */
    int vel = (int)(IN0(3)); /* INPUT 3 = NOTE VELOCITY */
    if (tr > 0.0 && unit->m_prev_tr <= 0.0) {
        unit->m_lfo.keydown();
        unit->m_dx7_note->init(unit->m_dx7_data, mnn, vel);
        if (unit->m_dx7_data[136]) {
            unit->m_dx7_note->oscSync();
        }
    } else if (tr <= 0.0 && unit->m_prev_tr > 0.0) {
        unit->m_dx7_note->keyup();
    }
    int32_t lfovalue = unit->m_lfo.getsample();
    int32_t lfodelay = unit->m_lfo.getdelay();
    for (int i = 0; i < inNumSamples; i += N) {
        fprintf(stderr,"RDX7: SUBFRAME: i=%d\n",i);
        AlignedBuf<int32_t, N> audiobuf;
        for (int j = 0; j < N; j++) {
            audiobuf.get()[j] = 0;
        }
        unit->m_dx7_note->compute(audiobuf.get(), lfovalue, lfodelay, &(unit->m_controllers));
        for (int j = 0; j < N; j++) {
            int32_t val = audiobuf.get()[j];
            val = val >> 4;
            int clip_val = val < -(1 << 24) ? 0x8000 : val >= (1 << 24) ? 0x7fff : val >> 9;
            float f = ((float) clip_val) / (float) 0x8000;
            if( f > 1 ) f = 1;
            if( f < -1 ) f = -1;
            out[i + j] = f;
            audiobuf.get()[j] = 0;
        }
    }
    unit->m_prev_tr = tr;
}

void RDX7_Dtor(RDX7 *unit)
{
    delete unit->m_dx7_note;
}

rdu_load_dtor(RDX7);
