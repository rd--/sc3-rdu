#include <stdio.h>
#include <SC_PlugIn.h>
#include "rdu.h"

static InterfaceTable *ft;

struct RandN : public Unit {};
struct ExpRandN : public Unit {};

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

PluginLoad(RandN)
{
  ft = inTable;
  DefineSimpleUnit(RandN);
  DefineSimpleUnit(ExpRandN);
}
