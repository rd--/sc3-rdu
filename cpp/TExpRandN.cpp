#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct TExpRandN : public Unit {float m_trig, *m_store;};

void TExpRandN_gen(TExpRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    float lo = IN0(0);
    float hi = IN0(1);
    float z = hi / lo;
    RGen& rgen = *unit->mParent->mRGen;
    uint32 i;
    for (i=0;i<nc;i++) {
	unit->m_store[i] = pow(z,rgen.frand()) * lo;
    }
}

void TExpRandN_cpy(TExpRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    uint32 i;
    for (i=0;i<nc;i++) {
	OUT0(i) = unit->m_store[i];
    }
}

void TExpRandN_next_k(TExpRandN* unit, int inNumSamples)
{
    float trig = IN0(2);
    if (trig > 0.f && unit->m_trig <= 0.f) {
	TExpRandN_gen(unit);
    }
    TExpRandN_cpy(unit);
    unit->m_trig = trig;
}

void TExpRandN_Ctor(TExpRandN* unit)
{
    unit->m_store = (float*)RTAlloc(unit->mWorld,unit->mNumOutputs * sizeof(float));
    TExpRandN_gen(unit);
    TExpRandN_cpy(unit);
    SETCALC(TExpRandN_next_k);
    unit->m_trig = IN0(2);
    TExpRandN_next_k(unit, 1);
}

void TExpRandN_Dtor(TExpRandN *unit)
{
    RTFree(unit->mWorld,unit->m_store);
}

PluginLoad(TExpRandN)
{
  ft = inTable;
  DefineDtorUnit(TExpRandN);
}
