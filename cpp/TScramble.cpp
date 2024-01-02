#include <SC_PlugIn.h>

#include "rdu.hpp"

static InterfaceTable *ft;

struct TScramble : public Unit {
	float *m_store;
	float m_prev_t;
};

void TScramble_step(TScramble *unit, int i)
{
	uint32_t inputCount = unit->mNumInputs - 1;
	for (uint32_t j = 0; j < inputCount; j++) {
		unit->m_store[j] = getInput(unit, j + 1, i);
	}
	for (uint32_t j = 0; j < inputCount - 1; j++) {
		int32_t k = (int32_t)j + unit->mParent->mRGen->irand((int32_t)inputCount - j);
		float tmp = unit->m_store[j];
		unit->m_store[j] = unit->m_store[k];
		unit->m_store[k] = tmp;
	}
}

void TScramble_next(TScramble *unit, int inNumSamples)
{
	float *in = IN(0);
	for (int i = 0; i < inNumSamples; i++) {
		float t = in[i];
		if (t > 0.0 && unit->m_prev_t <= 0.0) {
			TScramble_step(unit, i);
		}
		for (uint32_t j = 0; j < unit->mNumInputs - 1; j++) {
			unit->mOutBuf[j][i] = unit->m_store[j];
		}
		unit->m_prev_t = t;
	}
}

void TScramble_Ctor(TScramble *unit)
{
	uint32_t inputCount = unit->mNumInputs - 1;
	unit->m_store = (float *)RTAlloc(unit->mWorld, inputCount * sizeof(float));
	unit->m_prev_t = IN0(0);
	SETCALC(TScramble_next);
	for (uint32_t i = 0; i < inputCount; i++) {
		unit->m_store[i] = IN0(i + 1);
	}
	TScramble_next(unit, 1);
}

void TScramble_Dtor(TScramble *unit)
{
	RTFree(unit->mWorld, unit->m_store);
}

PluginLoad(TScramble)
{
	ft = inTable;
	DefineDtorUnit(TScramble);
}
