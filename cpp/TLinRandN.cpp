#include <SC_PlugIn.h>

#include "rdu.hpp"

static InterfaceTable *ft;

struct TLinRandN : public Unit {
	float m_trig;
	float *m_store;
};

void TLinRandN_gen(TLinRandN *unit, float lo, float hi, float minMax)
{
	float range = hi - lo;
	RGen &rgen = *unit->mParent->mRGen;
	for (uint32 i = 0; i < unit->mNumOutputs; i++) {
		float a = rgen.frand();
		float b = rgen.frand();
		if (minMax <= 0) {
			unit->m_store[i] = sc_min(a, b) * range + lo;
		} else {
			unit->m_store[i] = sc_max(a, b) * range + lo;
		}
	}
}

void TLinRandN_next(TLinRandN *unit, int inNumSamples)
{
	GetInput getLo = genGet(unit, 0);
	GetInput getHi = genGet(unit, 1);
	GetInput getMinMax = genGet(unit, 2);
	GetInput getTrig = genGet(unit, 3);
	for (int i = 0; i < inNumSamples; i++) {
		float trig = getTrig(i);
		if (trig > 0.f && unit->m_trig <= 0.f) {
			TLinRandN_gen(unit, getLo(i), getHi(i), getMinMax(i));
		}
		for (uint32 j = 0; j < unit->mNumOutputs; j++) {
			unit->mOutBuf[j][i] = unit->m_store[j];
		}
		unit->m_trig = trig;
	}
}

void TLinRandN_Ctor(TLinRandN *unit)
{
	unit->m_store = (float *)RTAlloc(unit->mWorld, unit->mNumOutputs * sizeof(float));
	unit->m_trig = IN0(3);
	TLinRandN_gen(unit, IN0(0), IN0(1), IN0(2));
	SETCALC(TLinRandN_next);
	TLinRandN_next(unit, 1);
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
