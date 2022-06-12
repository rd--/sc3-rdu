#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include <SC_PlugIn.h>

#define TSort_debug false

static InterfaceTable *ft;

struct TSort : public Unit {
  float *m_store;
  float m_prev_t;
};

int TSort_compare(const void *p1, const void *p2)
{
    float f1 = *((float *)p1);
    float f2 = *((float *)p2);
    if(TSort_debug) fprintf(stderr, "TSort_compare: %f, %f\n", f1, f2);
    return (f1 > f2 ? 1 : (f1 < f2 ? -1  :0));
}

void TSort_step(TSort* unit)
{
  float *d = unit->m_store;
  int k = unit->mNumInputs - 1;
  for (int i = 0; i < k; i++) {
    d[i] = IN0(i+1);
    if(TSort_debug) fprintf(stderr, "TSort_step: pre: %d -> %f\n", i, d[i]);
  }
  qsort(d, k, sizeof(float), TSort_compare);
  if(TSort_debug) {
      for (int i = 0; i < k; i++) {
          fprintf(stderr, "TSort_step: post: %d -> %f\n", i, d[i]);
      }
  }
}

void TSort_next(TSort *unit,int inNumSamples)
{
  float *in = IN(0);
  int k = unit->mNumInputs - 1;
  for(int i = 0; i < inNumSamples; i++) {
      float t = in[i];
      if (t > 0.0 && unit->m_prev_t <= 0.0) {
          TSort_step(unit);
      }
      for (int j = 0; j < k; j++) {
          OUT(j)[i] = unit->m_store[j];
      }
      unit->m_prev_t = t;
  }
}

void TSort_Ctor(TSort* unit)
{
  int k = unit->mNumInputs - 1;
  unit->m_store = (float*)RTAlloc(unit->mWorld, k * sizeof(float));
  unit->m_prev_t = 0;
  SETCALC(TSort_next);
  for (int i = 0; i < k; i++) {
    unit->m_store[i] = IN0(i + 1);
  }
  TSort_next(unit, 1);
}

void TSort_Dtor(TSort *unit)
{
  RTFree(unit->mWorld,unit->m_store);
}

PluginLoad(TSort)
{
  ft = inTable;
  DefineDtorUnit(TSort);
}
