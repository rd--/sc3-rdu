#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct RTExpRandN : public Unit {float m_trig, *m_store;};

void RTExpRandN_gen(RTExpRandN* unit)
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

void RTExpRandN_cpy(RTExpRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    uint32 i;
    for (i=0;i<nc;i++) {
	OUT0(i) = unit->m_store[i];
    }
}

void RTExpRandN_next_k(RTExpRandN* unit, int inNumSamples)
{
    float trig = IN0(2);
    if (trig > 0.f && unit->m_trig <= 0.f) {
	RTExpRandN_gen(unit);
    }
    RTExpRandN_cpy(unit);
    unit->m_trig = trig;
}

void RTExpRandN_Ctor(RTExpRandN* unit)
{
    unit->m_store = (float*)RTAlloc(unit->mWorld,unit->mNumOutputs * sizeof(float));
    RTExpRandN_gen(unit);
    RTExpRandN_cpy(unit);
    SETCALC(RTExpRandN_next_k);
    unit->m_trig = IN0(2);
    RTExpRandN_next_k(unit, 1);
}

void RTExpRandN_Dtor(RTExpRandN *unit)
{
    RTFree(unit->mWorld,unit->m_store);
}

PluginLoad(RTExpRandN)
{
  ft = inTable;
  DefineDtorUnit(RTExpRandN);
}
