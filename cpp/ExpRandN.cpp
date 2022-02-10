#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct ExpRandN : public Unit {};

void ExpRandN_Ctor(ExpRandN* unit)
{
  float l = IN0(0);
  float r = IN0(1);
  float z = r / l;
  uint32 nc = unit->mNumOutputs;
  RGen& rgen = *unit->mParent->mRGen;
  uint32 i;
  for (i=0;i<nc;i++) {
    OUT0(i) = pow(z,rgen.frand()) * l;
  }
}

PluginLoad(ExpRandN)
{
  ft = inTable;
  DefineSimpleUnit(ExpRandN);
}
