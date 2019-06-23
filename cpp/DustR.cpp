#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct DustR : public Unit
{
  int32 mCounter;
};

void DustR_next(DustR *unit, int inNumSamples)
{
  float *out = OUT(0);
  float iot_min = IN0(0);
  float iot_max = IN0(1);
  int32 counter = unit->mCounter;
  RGET
  for(int32 i = 0; i < inNumSamples; i++) {
    if (counter <= 0) {
      float z = frand(s1,s2,s3);
      out[i] = z;
      z = (z * (iot_max - iot_min)) + iot_min;
      counter = (int32) (z * unit->mRate->mSampleRate);
    } else  {
      out[0] = 0.f;
    }
    counter -= 1;
  }
  unit->mCounter = counter;
  RPUT
}

void DustR_Ctor(DustR *unit)
{
  unit->mCounter = 0;
  SETCALC(DustR_next);
  DustR_next(unit, 1);
}

PluginLoad(DustR)
{
  ft = inTable;
  DefineSimpleUnit(DustR);
}
