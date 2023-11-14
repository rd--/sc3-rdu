#include <stdio.h>

#include <SC_PlugIn.h>

#include "r-common/c/gen-trapezoid.c"
#include "r-common/c/segment-transfer.c"

static InterfaceTable *ft;

struct EnvTrapezoid : public Unit
{
    float trig;
    uint32_t dur;
    uint32_t count;
    float env[8];
};

void EnvTrapezoid_next(EnvTrapezoid *unit,int inNumSamples)
{
    float *trig = IN(0);
    float dur = IN0(1);
    float shape = IN0(2);
    float skew = IN0(3);
    for(int i = 0; i < inNumSamples; i++) {
        if(trig[i] > 0.0 && unit->trig <= 0.0) {
            unit->count = 0;
            unit->dur = dur * unit->mRate->mSampleRate;
            fprintf(stderr, "EnvTrapezoid: %f %f %f %f, %d %d\n", trig[i], dur, shape, skew, unit->count, unit->dur);
            gen_trapezoid(unit->env, 8, 1, shape, skew);
        }
        if(unit->count < unit->dur) {
            OUT(0)[i] = segment_transfer_lookup_linear(unit->env, 8, (float)(unit->count) / (float)(unit->dur));
        } else {
            OUT(0)[i] = 0;
        }
        unit->count += 1;
        unit->trig = trig[i];
    }
}

void EnvTrapezoid_Ctor(EnvTrapezoid *unit)
{
    unit->trig = 0;
    unit->count = 0;
    unit->dur = 0;
    SETCALC(EnvTrapezoid_next);
    EnvTrapezoid_next(unit, 1);
}


PluginLoad(EnvTrapezoid)
{
    ft = inTable;
    DefineSimpleUnit(EnvTrapezoid);
}
