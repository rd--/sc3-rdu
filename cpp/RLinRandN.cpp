#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct RLinRandN : public Unit {};

void RLinRandN_Ctor(RLinRandN* unit)
{
  float lo = IN0(0);
  float hi = IN0(1);
  int minmax = (int)IN0(2);
  float range = hi - lo;
  uint32 nc = unit->mNumOutputs;
  RGen& rgen = *unit->mParent->mRGen;
  uint32 i;
  for (i=0;i<nc;i++) {
    float a = rgen.frand();
    float b = rgen.frand();
    if (minmax <= 0) {
      OUT0(i) = sc_min(a, b) * range + lo;
    } else {
      OUT0(i) = sc_max(a, b) * range + lo;
    }
  }
}

PluginLoad(RLinRandN)
{
  ft = inTable;
  DefineSimpleUnit(RLinRandN);
}
