#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct RTRandN : public Unit {float m_trig, *m_store;};

void RTRandN_gen(RTRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    float lo = IN0(0);
    float hi = IN0(1);
    float range = hi - lo;
    RGen& rgen = *unit->mParent->mRGen;
    uint32 i;
    for (i=0;i<nc;i++) {
	unit->m_store[i] = rgen.frand() * range + lo;
    }
}

void RTRandN_cpy(RTRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    uint32 i;
    for (i=0;i<nc;i++) {
	OUT0(i) = unit->m_store[i];
    }
}

void RTRandN_next_k(RTRandN* unit, int inNumSamples)
{
    float trig = IN0(2);
    if (trig > 0.f && unit->m_trig <= 0.f) {
	RTRandN_gen(unit);
    }
    RTRandN_cpy(unit);
    unit->m_trig = trig;
}

void RTRandN_Ctor(RTRandN* unit)
{
    unit->m_store = (float*)RTAlloc(unit->mWorld,unit->mNumOutputs * sizeof(float));
    RTRandN_gen(unit);
    RTRandN_cpy(unit);
    SETCALC(RTRandN_next_k);
    unit->m_trig = IN0(2);
    RTRandN_next_k(unit, 1);
}

void RTRandN_Dtor(RTRandN *unit)
{
    RTFree(unit->mWorld,unit->m_store);
}

PluginLoad(RTRandN)
{
  ft = inTable;
  DefineDtorUnit(RTRandN);
}
