#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct TScramble : public Unit {
	float *m_store;
	float m_prev_t;
};

void TScramble_step(TScramble *unit)
{
	uint32_t inputCount = unit->mNumInputs - 1;
	for (uint32_t i = 0; i < inputCount; i++) {
		unit->m_store[i] = IN0(i + 1);
	}
	for (uint32_t i = 0; i < inputCount - 1; i++) {
		int32_t j = (int32_t)i + unit->mParent->mRGen->irand((int32_t)inputCount - i);
		float tmp = unit->m_store[i];
		unit->m_store[i] = unit->m_store[j];
		unit->m_store[j] = tmp;
	}
}

void TScramble_next(TScramble *unit, int inNumSamples)
{
	float *in = IN(0);
	for (int i = 0; i < inNumSamples; i++) {
		float t = in[i];
		if (t > 0.0 && unit->m_prev_t <= 0.0) {
			TScramble_step(unit);
		}
		for (uint32_t j = 0; j < unit->mNumInputs - 1; j++) {
			OUT(j)
			[i] = unit->m_store[j];
		}
		unit->m_prev_t = t;
	}
}

void TScramble_Ctor(TScramble *unit)
{
	uint32_t inputCount = unit->mNumInputs - 1;
	unit->m_store = (float *)RTAlloc(unit->mWorld, inputCount * sizeof(float));
	unit->m_prev_t = 0;
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
