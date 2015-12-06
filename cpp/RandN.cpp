#include <stdio.h>
#include <SC_PlugIn.h>
#include "rdu.h"

static InterfaceTable *ft;

struct ExpRandN : public Unit {};
struct IRandN : public Unit {};
struct LinRandN : public Unit {};
struct RandN : public Unit {};
struct TRandN : public Unit {float m_trig, *m_store;};

void ExpRandN_Ctor(ExpRandN* unit)
{
  float l = ZIN0(0);
  float r = ZIN0(1);
  float z = r / l;
  uint32 nc = unit->mNumOutputs;
  RGen& rgen = *unit->mParent->mRGen;
  uint32 i;
  for (i=0;i<nc;i++) {
    ZOUT0(i) = pow(z,rgen.frand()) * l;
  }
}

void IRandN_Ctor(IRandN* unit)
{
  int lo = (int)ZIN0(0);
  int hi = (int)ZIN0(1);
  int range = hi - lo + 1;
  uint32 nc = unit->mNumOutputs;
  RGen& rgen = *unit->mParent->mRGen;
  uint32 i;
  for (i=0;i<nc;i++) {
    ZOUT0(i) = (float)(rgen.irand(range) + lo);
  }
}

void LinRandN_Ctor(LinRandN* unit)
{
  float lo = ZIN0(0);
  float hi = ZIN0(1);
  int n = (int)ZIN0(2);
  float range = hi - lo;
  uint32 nc = unit->mNumOutputs;
  RGen& rgen = *unit->mParent->mRGen;
  uint32 i;
  for (i=0;i<nc;i++) {
    float a, b;
    a = rgen.frand();
    b = rgen.frand();
    if (n <= 0) {
      ZOUT0(i) = sc_min(a, b) * range + lo;
    } else {
      ZOUT0(i) = sc_max(a, b) * range + lo;
    }
  }
}

void RandN_Ctor(RandN* unit)
{
  float l = ZIN0(0);
  float r = ZIN0(1);
  float d = r - l;
  uint32 nc = unit->mNumOutputs;
  RGen& rgen = *unit->mParent->mRGen;
  uint32 i;
  for (i=0;i<nc;i++) {
    ZOUT0(i) = rgen.frand() * d + l;
  }
}

void TRandN_gen(TRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    float lo = ZIN0(0);
    float hi = ZIN0(1);
    float range = hi - lo;
    RGen& rgen = *unit->mParent->mRGen;
    uint32 i;
    for (i=0;i<nc;i++) {
	unit->m_store[i] = rgen.frand() * range + lo;
    }
}

void TRandN_cpy(TRandN* unit)
{
    uint32 nc = unit->mNumOutputs;
    uint32 i;
    for (i=0;i<nc;i++) {
	ZOUT0(i) = unit->m_store[i];
    }
}

void TRandN_next_k(TRandN* unit, int inNumSamples)
{
    float trig = ZIN0(2);
    if (trig > 0.f && unit->m_trig <= 0.f) {
	TRandN_gen(unit);
    }
    TRandN_cpy(unit);
    unit->m_trig = trig;
}

void TRandN_Ctor(TRandN* unit)
{
    unit->m_store = (float*)RTAlloc(unit->mWorld,unit->mNumOutputs * sizeof(float));
    TRandN_gen(unit);
    TRandN_cpy(unit);
    SETCALC(TRandN_next_k);
    unit->m_trig = ZIN0(2);
}

void TRandN_Dtor(TRandN *unit)
{
    RTFree(unit->mWorld,unit->m_store);
}

PluginLoad(RandN)
{
  ft = inTable;
  DefineSimpleUnit(ExpRandN);
  DefineSimpleUnit(IRandN);
  DefineSimpleUnit(LinRandN);
  DefineSimpleUnit(RandN);
  DefineDtorUnit(TRandN);
}
