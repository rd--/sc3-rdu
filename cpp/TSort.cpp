#include <stdlib.h> // qsort

#include <SC_PlugIn.h>

#include "r-common/c/compare.h"

#include "rdu.hpp"

static InterfaceTable *ft;

struct TSort : public Unit {
	float *m_store;
	float m_prev_trig;
};

void TSort_step(TSort *unit)
{
	float *d = unit->m_store;
	int k = unit->mNumInputs - 1;
	for (int i = 0; i < k; i++) {
		d[i] = IN0(i + 1);
	}
	qsort(d, k, sizeof(float), compare_float);
}

void TSort_next(TSort *unit, int inNumSamples)
{
	GetInput getTrig = genGet(unit, 0);
	int inputCount = unit->mNumInputs - 1;
	for (int i = 0; i < inNumSamples; i++) {
		float trig = getTrig(i);
		if (trig > 0.0 && unit->m_prev_trig <= 0.0) {
			TSort_step(unit);
		}
		for (int j = 0; j < inputCount; j++) {
			unit->mOutBuf[j][i] = unit->m_store[j];
		}
		unit->m_prev_trig = trig;
	}
}

void TSort_Ctor(TSort *unit)
{
	int inputCount = unit->mNumInputs - 1;
	unit->m_store = (float *)RTAlloc(unit->mWorld, inputCount * sizeof(float));
	unit->m_prev_trig = IN0(0);
	SETCALC(TSort_next);
	for (int i = 0; i < inputCount; i++) {
		unit->m_store[i] = IN0(i + 1);
	}
	TSort_next(unit, 1);
}

void TSort_Dtor(TSort *unit)
{
	RTFree(unit->mWorld, unit->m_store);
}

PluginLoad(TSort)
{
	ft = inTable;
	DefineDtorUnit(TSort);
}
