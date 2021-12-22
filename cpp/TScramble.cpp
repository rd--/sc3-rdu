#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct TScramble : public Unit {
  float *m_store;
  float m_prev_t;
};

void TScramble_step(TScramble* unit)
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

void TScramble_next(TScramble *unit,int inNumSamples)
{
  float *in = IN(0);
  int k = unit->mNumInputs - 1;
  for(int i = 0; i < inNumSamples; i++) {
      float t = in[i];
      if (t > 0.0 && unit->m_prev_t <= 0.0) {
          TScramble_step(unit);
      }
      for (int j = 0; j < k; j++) {
          OUT(j)[i] = unit->m_store[j];
      }
      unit->m_prev_t = t;
  }
}

void TScramble_Ctor(TScramble* unit)
{
  int k = unit->mNumInputs - 1;
  unit->m_store = (float*)RTAlloc(unit->mWorld, k * sizeof(float));
  unit->m_prev_t = 0;
  SETCALC(TScramble_next);
  for (int i = 0; i < k; i++) {
    unit->m_store[i] = IN0(i + 1);
  }
  TScramble_next(unit, 1);
}

void TScramble_Dtor(TScramble *unit)
{
  RTFree(unit->mWorld,unit->m_store);
}

PluginLoad(TScramble)
{
  ft = inTable;
  DefineDtorUnit(TScramble);
}
