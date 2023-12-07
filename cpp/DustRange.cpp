#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct DustRange : public Unit {
	int32 mCounter;
};

void DustRange_next(DustRange *unit, int inNumSamples)
{
	float *out = OUT(0);
	float iot_min = IN0(0);
	float iot_max = IN0(1);
	int32 counter = unit->mCounter;
	RGen &rgen = *unit->mParent->mRGen;
	for (int32 i = 0; i < inNumSamples; i++) {
		if (counter <= 0) {
			float z = rgen.frand();
			out[i] = z;
			z = (z * (iot_max - iot_min)) + iot_min;
			counter = (int32)(z * unit->mRate->mSampleRate);
		} else {
			out[i] = 0.0;
		}
		counter -= 1;
	}
	unit->mCounter = counter;
}

void DustRange_Ctor(DustRange *unit)
{
	unit->mCounter = 0;
	SETCALC(DustRange_next);
	DustRange_next(unit, 1);
}

PluginLoad(DustRange)
{
	ft = inTable;
	DefineSimpleUnit(DustRange);
}
