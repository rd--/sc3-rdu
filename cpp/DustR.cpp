#include <stdio.h>
#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct DustR : public Unit
{
  int32 mCounter;
};

extern "C"
{
  void load(InterfaceTable *inTable);
  void DustR_Ctor(DustR *unit);
  void DustR_next(DustR *unit, int inNumSamples);
}

void DustR_Ctor(DustR *unit)
{	
  SETCALC(DustR_next);
  unit->mCounter = 0;
  DustR_next(unit, 1);
}

void DustR_next(DustR *unit, int inNumSamples)
{
  float *out = ZOUT(0);
  float iot_min = ZIN0(0);
  float iot_max = ZIN0(1);
  int32 counter = unit->mCounter;
  RGET
  LOOP(inNumSamples, 
       if (counter <= 0) {
	 float z = frand(s1,s2,s3);
	 ZXP(out) = z;
	 z = (z * (iot_max - iot_min)) + iot_min;
	 counter = (int32) (z * unit->mRate->mSampleRate);
       } else  {
	 ZXP(out) = 0.f;
       }
       counter -= 1;
       );
  unit->mCounter = counter;
  RPUT
}

void load(InterfaceTable *inTable)
{
  ft = inTable;
  DefineSimpleUnit(DustR);
}
