#include <SC_PlugIn.h>

#include "rdu.hpp"

static InterfaceTable *ft;

struct TRandN : public Unit {
	float m_trig;
	float *m_store;
};

void TRandN_gen(TRandN *unit, float lo, float hi)
{
	float range = hi - lo;
	RGen &rgen = *unit->mParent->mRGen;
	for (uint32 i = 0; i < unit->mNumOutputs; i++) {
		unit->m_store[i] = rgen.frand() * range + lo;
	}
}

void TRandN_next(TRandN *unit, int inNumSamples)
{
	GetInput getLo = genGet(unit, 0);
	GetInput getHi = genGet(unit, 1);
	GetInput getTrig = genGet(unit, 2);
	for (int i = 0; i < inNumSamples; i++) {
		float trig = getTrig(i);
		if (trig > 0.f && unit->m_trig <= 0.f) {
			TRandN_gen(unit, getLo(i), getHi(i));
		}
		for (uint32 j = 0; j < unit->mNumOutputs; j++) {
			unit->mOutBuf[j][i] = unit->m_store[j];
		}
		unit->m_trig = trig;
	}
}

void TRandN_Ctor(TRandN *unit)
{
	unit->m_store = (float *)RTAlloc(unit->mWorld, unit->mNumOutputs * sizeof(float));
	unit->m_trig = IN0(2);
	TRandN_gen(unit, IN0(0), IN0(1));
	SETCALC(TRandN_next);
	TRandN_next(unit, 1);
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
