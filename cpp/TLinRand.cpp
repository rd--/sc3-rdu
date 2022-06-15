#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct TLinRand : public Unit {
    float m_trig;
    float m_store;
};

void TLinRand_gen(TLinRand *unit)
{
    float lo = IN0(0);
    float hi = IN0(1);
    int minmax = (int)IN0(2);
    float range = hi - lo;
    RGen &rgen = *unit->mParent->mRGen;
    float a = rgen.frand();
    float b = rgen.frand();
    if (minmax <= 0) {
	unit->m_store = sc_min(a, b) * range + lo;
    } else {
	unit->m_store = sc_max(a, b) * range + lo;
    }
}

void TLinRand_next_k(TLinRand *unit, int inNumSamples)
{
    float trig = IN0(3);
    if (trig > 0.f && unit->m_trig <= 0.f) {
        TLinRand_gen(unit);
    }
    OUT0(0) = unit->m_store;
    unit->m_trig = trig;
}

void TLinRand_Ctor(TLinRand *unit)
{
    unit->m_store = 0.0;
    TLinRand_gen(unit);
    SETCALC(TLinRand_next_k);
    unit->m_trig = IN0(3);
    TLinRand_next_k(unit, 1);
}

PluginLoad(TLinRand)
{
    ft = inTable;
    DefineSimpleUnit(TLinRand);
}
