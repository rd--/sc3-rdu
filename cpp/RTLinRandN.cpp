#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct RTLinRandN : public Unit {float m_trig, *m_store;};

void RTLinRandN_gen(RTLinRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    float lo = IN0(0);
    float hi = IN0(1);
    int minmax = (int)IN0(2);
    float range = hi - lo;
    RGen& rgen = *unit->mParent->mRGen;
    uint32 i;
    for (i=0;i<nc;i++) {
        float a = rgen.frand();
        float b = rgen.frand();
        if (minmax <= 0) {
            unit->m_store[i] = sc_min(a, b) * range + lo;
        } else {
            unit->m_store[i] = sc_max(a, b) * range + lo;
        }
    }
}

void RTLinRandN_cpy(RTLinRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    uint32 i;
    for (i=0;i<nc;i++) {
	OUT0(i) = unit->m_store[i];
    }
}

void RTLinRandN_next_k(RTLinRandN* unit, int inNumSamples)
{
    float trig = IN0(3);
    if (trig > 0.f && unit->m_trig <= 0.f) {
	RTLinRandN_gen(unit);
    }
    RTLinRandN_cpy(unit);
    unit->m_trig = trig;
}

void RTLinRandN_Ctor(RTLinRandN* unit)
{
    unit->m_store = (float*)RTAlloc(unit->mWorld,unit->mNumOutputs * sizeof(float));
    RTLinRandN_gen(unit);
    RTLinRandN_cpy(unit);
    SETCALC(RTLinRandN_next_k);
    unit->m_trig = IN0(3);
    RTLinRandN_next_k(unit, 1);
}

void RTLinRandN_Dtor(RTLinRandN *unit)
{
    RTFree(unit->mWorld,unit->m_store);
}

PluginLoad(RTLinRandN)
{
  ft = inTable;
  DefineDtorUnit(RTLinRandN);
}
