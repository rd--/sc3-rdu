#include <stdio.h>
#include <SC_PlugIn.h>
#include "rdu.h"

static InterfaceTable *ft;

struct DustR : public Unit
{
  int32 mCounter;
};

rdu_prototypes(DustR);

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
  SETCALC(DustR_next);
  unit->mCounter = 0;
  DustR_next(unit, 1);
}

rdu_load(DustR);
