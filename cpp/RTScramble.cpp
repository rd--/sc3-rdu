#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct RTScramble : public Unit {
  float *m_store;
  float m_prev_t;
};

void RTScramble_step(RTScramble* unit)
{
  float *d = unit->m_store;
  RGen& rgen = *unit->mParent->mRGen;
  int k = unit->mNumInputs - 1;
  for (int i = 0; i < k; i++) {
    d[i] = IN0(i+1);
  }
  for (int i = 0; i < k - 1; i++) {
    int j = i + rgen.irand(k - i);
    float t = d[i];
    d[i] = d[j];
    d[j] = t;
  }
}

void RTScramble_next(RTScramble *unit,int inNumSamples)
{
  int k = unit->mNumInputs - 1;
  float t = IN0(0);
  if (t > 0.0 && unit->m_prev_t <= 0.0) {
    RTScramble_step(unit);
  }
  for (int i = 0; i < k; i++) {
    OUT0(i) = unit->m_store[i];
  }
  unit->m_prev_t = t;
}

void RTScramble_Ctor(RTScramble* unit)
{
  int k = unit->mNumInputs - 1;
  unit->m_store = (float*)RTAlloc(unit->mWorld, k * sizeof(float));
  unit->m_prev_t = 0;
  SETCALC(RTScramble_next);
  for (int i = 0; i < k; i++) {
    unit->m_store[i] = IN0(i + 1);
  }
  RTScramble_next(unit, 1);
}

void RTScramble_Dtor(RTScramble *unit)
{
  RTFree(unit->mWorld,unit->m_store);
}

PluginLoad(RTScramble)
{
  ft = inTable;
  DefineDtorUnit(RTScramble);
}
