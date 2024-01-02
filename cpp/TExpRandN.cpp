#include <SC_PlugIn.h>

#include "rdu.hpp"

static InterfaceTable *ft;

struct TExpRandN : public Unit {
	float m_trig;
	float *m_store;
};

void TExpRandN_gen(TExpRandN *unit, float lo, float hi)
{
	float z = hi / lo;
	RGen &rgen = *unit->mParent->mRGen;
	for (uint32 i = 0; i < unit->mNumOutputs; i++) {
		unit->m_store[i] = pow(z, rgen.frand()) * lo;
	}
}

void TExpRandN_next(TExpRandN *unit, int inNumSamples)
{
	GetInput getLo = genGet(unit, 0);
	GetInput getHi = genGet(unit, 1);
	GetInput getTrig = genGet(unit, 2);
	for (int i = 0; i < inNumSamples; i++) {
		float trig = getTrig(i);
		if (trig > 0.f && unit->m_trig <= 0.f) {
			TExpRandN_gen(unit, getLo(i), getHi(i));
		}
		for (uint32 j = 0; j < unit->mNumOutputs; j++) {
			unit->mOutBuf[j][i] = unit->m_store[j];
		}
		unit->m_trig = trig;
	}
}

void TExpRandN_Ctor(TExpRandN *unit)
{
	unit->m_store = (float *)RTAlloc(unit->mWorld, unit->mNumOutputs * sizeof(float));
	unit->m_trig = IN0(2);
	TExpRandN_gen(unit, IN0(0), IN0(1));
	SETCALC(TExpRandN_next);
	TExpRandN_next(unit, 1);
}

void TExpRandN_Dtor(TExpRandN *unit)
{
	RTFree(unit->mWorld, unit->m_store);
}

PluginLoad(TExpRandN)
{
	ft = inTable;
	DefineDtorUnit(TExpRandN);
}
