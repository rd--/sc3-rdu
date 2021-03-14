#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct TScramble : public Unit {
  float *m_store;
  float m_prev_t;
};

void TScramble_step(TScramble* unit)
{
  int i,j,k,m;
  float *d = unit->m_store;
  RGen& rgen = *unit->mParent->mRGen;
  k = unit->mNumInputs - 1;
  for (i=0, m=k; i<k-1; ++i, --m) {
    float t;
    j = i + rgen.irand(m);
    t = d[i];
    d[i] = d[j];
    d[j] = t;
  }
}

void TScramble_next(TScramble *unit,int inNumSamples)
{
  int i;
  int k = unit->mNumInputs - 1;
  float t = IN0(0);
  if (t > 0.0 && unit->m_prev_t <= 0.0) {
    for (i=0; i<k; i++) {
      unit->m_store[i] = IN0(i+1);
    }
    TScramble_step(unit);
  }
  for (i=0; i<k; i++) {
    OUT0(i) = unit->m_store[i];
  }
  unit->m_prev_t = t;
}

void TScramble_Ctor(TScramble* unit)
{
  int i, k;
  k = unit->mNumInputs - 1;
  unit->m_store = (float*)RTAlloc(unit->mWorld, k * sizeof(float));
  unit->m_prev_t = 0;
  SETCALC(TScramble_next);
  for (i=0;i<k;i++) {
    OUT0(i) = IN0(i+1);
  }
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