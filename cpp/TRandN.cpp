#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct TRandN : public Unit {
    float m_trig;
    float *m_store;
};

void TRandN_gen(TRandN *unit)
{
    uint32 nc = unit->mNumOutputs;
    float lo = IN0(0);
    float hi = IN0(1);
    float range = hi - lo;
    RGen &rgen = *unit->mParent->mRGen;
    uint32 i;
    for (i = 0; i < nc; i++) {
        unit->m_store[i] = rgen.frand() * range + lo;
    }
}

void TRandN_cpy(TRandN *unit)
{
    uint32 nc = unit->mNumOutputs;
    uint32 i;
    for (i = 0; i < nc; i++) {
        OUT0(i) = unit->m_store[i];
    }
}

void TRandN_next_k(TRandN *unit, int inNumSamples)
{
    float trig = IN0(2);
    if (trig > 0.f && unit->m_trig <= 0.f) {
        TRandN_gen(unit);
    }
    TRandN_cpy(unit);
    unit->m_trig = trig;
}

void TRandN_Ctor(TRandN *unit)
{
    unit->m_store = (float *)RTAlloc(unit->mWorld, unit->mNumOutputs * sizeof(float));
    TRandN_gen(unit);
    TRandN_cpy(unit);
    SETCALC(TRandN_next_k);
    unit->m_trig = IN0(2);
    TRandN_next_k(unit, 1);
}

void TRandN_Dtor(TRandN *unit)
{
    RTFree(unit->mWorld, unit->m_store);
}

PluginLoad(TRandN)
{
    ft = inTable;
    DefineDtorUnit(TRandN);
}
