#include <stdio.h>
#include <SC_PlugIn.h>
#include "rdu.h"

static InterfaceTable *ft;

struct RandN : public Unit {};
struct ExpRandN : public Unit {};
struct LinRandN : public Unit {};

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

PluginLoad(RandN)
{
  ft = inTable;
  DefineSimpleUnit(RandN);
  DefineSimpleUnit(ExpRandN);
  DefineSimpleUnit(LinRandN);
}
