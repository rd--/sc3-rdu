#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct RRandN : public Unit {};

void RRandN_Ctor(RRandN* unit)
{
  float l = IN0(0);
  float r = IN0(1);
  float d = r - l;
  uint32 nc = unit->mNumOutputs;
  RGen& rgen = *unit->mParent->mRGen;
  uint32 i;
  for (i=0;i<nc;i++) {
    OUT0(i) = rgen.frand() * d + l;
  }
}

PluginLoad(RRandN)
{
  ft = inTable;
  DefineSimpleUnit(RRandN);
}
