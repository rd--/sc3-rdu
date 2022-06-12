#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct TLinRandN : public Unit {
    float m_trig;
    float *m_store;
};

void TLinRandN_gen(TLinRandN *unit)
{
    uint32 nc = unit->mNumOutputs;
    float lo = IN0(0);
    float hi = IN0(1);
    int minmax = (int)IN0(2);
    float range = hi - lo;
    RGen &rgen = *unit->mParent->mRGen;
    uint32 i;
    for (i = 0; i < nc; i++) {
        float a = rgen.frand();
        float b = rgen.frand();
        if (minmax <= 0) {
            unit->m_store[i] = sc_min(a, b) * range + lo;
        } else {
            unit->m_store[i] = sc_max(a, b) * range + lo;
        }
    }
}

void TLinRandN_cpy(TLinRandN *unit)
{
    uint32 nc = unit->mNumOutputs;
    uint32 i;
    for (i = 0; i < nc; i++) {
        OUT0(i) = unit->m_store[i];
    }
}

void TLinRandN_next_k(TLinRandN *unit, int inNumSamples)
{
    float trig = IN0(3);
    if (trig > 0.f && unit->m_trig <= 0.f) {
        TLinRandN_gen(unit);
    }
    TLinRandN_cpy(unit);
    unit->m_trig = trig;
}

void TLinRandN_Ctor(TLinRandN *unit)
{
    unit->m_store = (float *)RTAlloc(unit->mWorld, unit->mNumOutputs * sizeof(float));
    TLinRandN_gen(unit);
    TLinRandN_cpy(unit);
    SETCALC(TLinRandN_next_k);
    unit->m_trig = IN0(3);
    TLinRandN_next_k(unit, 1);
}

void TLinRandN_Dtor(TLinRandN *unit)
{
    RTFree(unit->mWorld, unit->m_store);
}

PluginLoad(TLinRandN)
{
    ft = inTable;
    DefineDtorUnit(TLinRandN);
}
