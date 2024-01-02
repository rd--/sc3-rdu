#include <SC_PlugIn.h>

#include "rdu.hpp"

static InterfaceTable *ft;

struct TLinRand : public Unit {
	float m_trig;
	float m_store;
};

void TLinRand_gen(TLinRand *unit, float lo, float hi, float minMax)
{
	float range = hi - lo;
	RGen &rgen = *unit->mParent->mRGen;
	float a = rgen.frand();
	float b = rgen.frand();
	if (minMax <= 0) {
		unit->m_store = sc_min(a, b) * range + lo;
	} else {
		unit->m_store = sc_max(a, b) * range + lo;
	}
}

void TLinRand_next(TLinRand *unit, int inNumSamples)
{
	GetInput getLo = genGet(unit, 0);
	GetInput getHi = genGet(unit, 1);
	GetInput getMinMax = genGet(unit, 2);
	GetInput getTrig = genGet(unit, 3);
	for (int i = 0; i < inNumSamples; i++) {
		float trig = getTrig(i);
		if (trig > 0.f && unit->m_trig <= 0.f) {
			TLinRand_gen(unit, getLo(i), getHi(i), getMinMax(i));
		}
		unit->mOutBuf[0][i] = unit->m_store;
		unit->m_trig = trig;
	}
}

void TLinRand_Ctor(TLinRand *unit)
{
	unit->m_store = 0.0;
	unit->m_trig = IN0(3);
	TLinRand_gen(unit, IN0(0), IN0(1), IN0(2));
	SETCALC(TLinRand_next);
	TLinRand_next(unit, 1);
}

PluginLoad(TLinRand)
{
	ft = inTable;
	DefineSimpleUnit(TLinRand);
}
