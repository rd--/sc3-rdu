/* https://github.com/asb2m10/dexed */
/* https://github.com/google/music-synthesizer-for-android */

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
/* #include "dx7/tuning.cc" 0.9.5 */

#include "dx7/EngineMkI.cpp"

#include "r-common/c/cfile.c"
#include "r-common/c/dx7.c"
#include "r-common/c/float.h"
#include "r-common/c/memory.c"
#include "r-common/c/print.h"

/* DEXED adds switches for each OP, this sets them, 0x3F turns everything on */
void unpack_op_switch(Controllers *c, uint8_t x)
{
    c->opSwitch[5] = ((x >> 5) & 1) + 48;
    c->opSwitch[4] = ((x >> 4) & 1) + 48;
    c->opSwitch[3] = ((x >> 3) & 1) + 48;
    c->opSwitch[2] = ((x >> 2) & 1) + 48;
    c->opSwitch[1] = ((x >> 1) & 1) + 48;
    c->opSwitch[0] = ((x >> 0) & 1) + 48;
}

void ctl_init(Controllers *c)
{
    c->values_[kControllerPitch] = 0x2000;
    c->values_[kControllerPitchRange] = 1; /* 0.9.5 = Dn/Up */
    c->values_[kControllerPitchStep] = 0;
    c->modwheel_cc = 0;
    c->foot_cc = 0;
    c->breath_cc = 0;
    c->aftertouch_cc = 0;
    c->masterTune = 0;
    c->refresh();
    c->core = new EngineMkI; /* ALLOC - FmCore */
    unpack_op_switch(c, 0x3F);
}

#define buf_zero(b, n)               \
    for (int _i = 0; _i < n; _i++) { \
        b.get()[_i] = 0;             \
    }

/* SC3 */
static InterfaceTable *ft;

struct DX7 : public Unit {
    Controllers m_ctl;
    Lfo m_lfo;
    Dx7Note *m_dx7_note;
    uint8_t m_dx7_data[155];
    float m_prev_gate_tr;
    float m_prev_reset_tr;
    float m_prev_data_tr;
    int m_reset_cnt;
    bool m_offline; /* INITIAL STATE */
    /* std::shared_ptr<TuningState> m_tuning; 0.9.5 */
    rdu_declare_buf(data);
};

rdu_prototypes_dtor(DX7)

    void DX7_Ctor(DX7 *unit)
{
    Freqlut::init(SAMPLERATE);
    Exp2::init();
    Tanh::init();
    Sin::init();
    Lfo::init(SAMPLERATE);
    PitchEnv::init(SAMPLERATE);
    Env::init_sr(SAMPLERATE);
    ctl_init(&(unit->m_ctl));
    /* unit->m_tuning = createStandardTuning(); 0 .9.5 */
    unit->m_dx7_note = new Dx7Note(); /* NON-RT, SHOULD OVER-RIDE CONSTRUCTOR */
    unit->m_prev_gate_tr = 0;
    unit->m_prev_reset_tr = 0;
    unit->m_prev_data_tr = 0;
    unit->m_reset_cnt = 0;
    dx7_init_voice(unit->m_dx7_data);
    unit->m_offline = true;
    rdu_init_buf(data);
    SETCALC(DX7_next);
    DX7_next(unit, 1);
}

/* (1 `shiftL` 24 == 0x1000000,0x8000 == 2^15,0x1000000 `shiftR` 9 == 0x8000) */
f32 mfsa_to_f32(i32 x0)
{
    i32 x1 = x0 >> 4;
    i32 x2 = x1 < -0x1000000 ? 0x8000 : (x1 >= 0x1000000 ? 0x7fff : (x1 >> 9));
    return ((f32)x2 / (f32)0x8000);
}

int dx7_mnn_calc(DX7 *unit, int mnn)
{
    return (mnn + (int)(unit->m_dx7_data[144]) - 24);
}

void dx7_buf_read(DX7 *unit, int vc)
{
    for (int i = 0; i < 155; i++) {
        unit->m_dx7_data[i] = (uint8_t)(unit->m_buf_data->data[(vc * 155) + i]);
    }
}

/* N = 64 ; REQUIRES inNumSamples be a multiple of N */
void DX7_next(DX7 *unit, int inNumSamples)
{
    float *out = OUT(0);
    rdu_get_buf(data, 0); /* INPUT 0 = VOICE-DATA BUFFER */
    rdu_check_buf(data, 1);
    float gate_tr = IN0(1); /* INPUT 1 = GATE TR */
    float reset_tr = IN0(2); /* INPUT 2 = RESET TR */
    float data_tr = IN0(3); /* INPUT 3 = DATA TR */
    int vc = (int)(IN0(4)); /* INPUT 4 = VOICE INDEX (PROGRAM NUMBER) */
    float fmnn = IN0(5); /* INPUT 5 = FRACTIONAL MIDI NOTE NUMBER */
    int mnn = (int)fmnn;
    int cents = (int)((fmnn - (float)mnn) * 100);
    int vel = (int)(IN0(6)); /* INPUT 6 = NOTE VELOCITY */
    unit->m_ctl.values_[kControllerPitch] = (int)(IN0(7)); /* INPUT 7 = PITCH-WHEEL (14-BIT) */
    unit->m_ctl.modwheel_cc = (int)(IN0(8)); /* INPUT 8 = MOD-WHEEL */
    unit->m_ctl.breath_cc = (int)(IN0(9)); /* INPUT 9 = BREATH-CTL */
    unit->m_ctl.foot_cc = (int)(IN0(10)); /* INPUT 10 = FOOT-CTL */
    unit->m_ctl.refresh();
    /* DATA TR - LOAD VOICE DATA AND UPDATE */
    if (data_tr > 0.0 && unit->m_prev_data_tr <= 0.0) {
        dx7_buf_read(unit, vc);
        if (!unit->m_offline) {
            unit->m_dx7_note->update(unit->m_dx7_data, dx7_mnn_calc(unit, mnn), cents, vel);
            unit->m_lfo.reset(unit->m_dx7_data + 137);
        }
    }
    bool is_note_on = gate_tr > 0.0 && unit->m_prev_gate_tr <= 0.0;
    bool is_note_off = gate_tr <= 0.0 && unit->m_prev_gate_tr > 0.0;
    bool is_reset = reset_tr > 0.0 && unit->m_prev_reset_tr <= 0.0;
    if (is_note_on || is_reset) {
        unit->m_offline = false;
        dx7_buf_read(unit, vc);
        unit->m_lfo.keydown(); /* ? */
        unit->m_dx7_note->init(unit->m_dx7_data, dx7_mnn_calc(unit, mnn), cents, vel);
        if (!is_note_on) {
            unit->m_reset_cnt += 1;
        }
        if (unit->m_dx7_data[136]) {
            unit->m_dx7_note->oscSync();
        }
    }
    if (is_note_off) {
        if (unit->m_reset_cnt == 0) {
            unit->m_dx7_note->keyup();
        } else if (unit->m_reset_cnt > 0) {
            unit->m_reset_cnt -= 1;
        } else if (!unit->m_offline) {
            fprintf(stderr, "DX7: unexpected note-off?\n");
        }
    }
    /* OFFLINE */
    if (unit->m_offline) {
        for (int i = 0; i < inNumSamples; i++) {
            out[i] = 0.0;
        }
        return;
    }
    /* PROCESS */
    for (int i = 0; i < inNumSamples; i += N) {
        dprintf("DX7: SUBFRAME: i=%d\n", i);
        int32_t lfovalue = unit->m_lfo.getsample();
        int32_t lfodelay = unit->m_lfo.getdelay();
        AlignedBuf<int32_t, N> audiobuf;
        buf_zero(audiobuf, N);
        unit->m_dx7_note->compute(audiobuf.get(), lfovalue, lfodelay, &(unit->m_ctl));
        for (int j = 0; j < N; j++) {
            int32_t x = audiobuf.get()[j];
            out[i + j] = mfsa_to_f32(x);
            audiobuf.get()[j] = 0;
        }
    }
    /* STATE */
    unit->m_prev_gate_tr = gate_tr;
    unit->m_prev_reset_tr = reset_tr;
    unit->m_prev_data_tr = data_tr;
}

void DX7_Dtor(DX7 *unit)
{
    delete unit->m_dx7_note;
}

rdu_load_dtor(DX7)
