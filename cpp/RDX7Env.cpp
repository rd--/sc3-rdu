/* https://github.com/asb2m10/dexed */
/* https://github.com/google/music-synthesizer-for-android */

#include <math.h>
#include <stdint.h>

#include <SC_PlugIn.h>

#include "dx7/env.cc"
#include "dx7/exp2.cc"

#include "c-commonr/int.h"
#include "c-commonr/float.h"
#include "c-commonr/print.h"

static InterfaceTable *ft;

struct RDX7Env : public Unit
{
    Env m_env;
    float m_prev_key_tr;
    float m_prev_data_tr;
    float m_prev_level_f;
    bool m_offline; /* INITIAL STATE */
};

void RDX7Env_cpy_param(RDX7Env *unit,bool is_init)
{
    int r[4],l[4]; /* INPUT 2-5 = RATE, INPUT 6-9 = LEVEL */
    for(int i = 0; i < 4; i++) {
        r[i] = (int)(IN0(2 + i));
        l[i] = (int)(IN0(2 + i + 4));
    }
    int ol0 = (int)(IN0(10)); /* INPUT 10 = OUTLEVEL */
    int ol1 = Env::scaleoutlevel(ol0);
    int ol2 = ol1 << 5;
    dprintf("r=%d,%d,%d,%d l=%d,%d,%d,%d ol=%d\n",r[0],r[1],r[2],r[3],l[0],l[1],l[2],l[3],ol2);
    if(is_init) {
        unit->m_env.init(r,l,ol2,0);
    } else {
        unit->m_env.update(r,l,ol2,0);
    }
}

/* (1 `shiftL` 24 == 0x1000000,0x8000 == 2^15,0x1000000 `shiftR` 9 == 0x8000) */
f32 dexed_to_f32(i32 x0)
{
    i32 x1 = x0 >> 4;
    i32 x2 = x1 < -0x1000000 ? 0x8000 : x1 >= 0x1000000 ? 0x7fff : (x1 >> 9);
    return ((f32)x2 / (f32)0x8000);
}

/* N = 64 ; REQUIRES inNumSamples be a multiple of N */
void RDX7Env_next(RDX7Env *unit,int inNumSamples)
{
    float *out = OUT(0);
    float key_tr = IN0(0); /* INPUT 0 = KEY GATE */
    float data_tr = IN0(1); /* INPUT 1 = DATA TRIGGER */
    if (key_tr > 0.0 && unit->m_prev_key_tr <= 0.0) {
        unit->m_offline = false;
        RDX7Env_cpy_param(unit,true);
    } else if (key_tr <= 0.0 && unit->m_prev_key_tr > 0.0) {
        unit->m_env.keydown(false);
    }
    if (data_tr > 0.0 && unit->m_prev_data_tr <= 0.0) {
        RDX7Env_cpy_param(unit,false);
    }
    if(unit->m_offline) {
        for (int i = 0; i < inNumSamples; i++) {
            out[i] = 0.0;
        }
    } else {
        for (int i = 0; i < inNumSamples; i += N) {
            i32 env_sig = unit->m_env.getsample();
            i32 next_level = Exp2::lookup(env_sig - (14 * (1 << 24)));
            f32 next_level_f = dexed_to_f32(next_level) * 8;
            f32 level = unit->m_prev_level_f;
            f32 incr = (next_level_f - level) / (f32)N;
            for (int j = 0; j < N; j++) {
                out[i + j] = level;
                level += incr;
            }
            unit->m_prev_level_f = next_level_f;
        }
    }
    unit->m_prev_key_tr = key_tr;
    unit->m_prev_data_tr = data_tr;
}

void RDX7Env_Ctor(RDX7Env *unit)
{
    Exp2::init();
    Env::init_sr(SAMPLERATE);
    unit->m_prev_key_tr = 0;
    unit->m_prev_data_tr = 0;
    unit->m_prev_level_f = 0.0;
    unit->m_offline = true;
    SETCALC(RDX7Env_next);
    RDX7Env_next(unit, 1);
}

PluginLoad(RDX7Env)
{
    ft = inTable;
    DefineSimpleUnit(RDX7Env);
}

