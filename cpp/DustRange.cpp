#include <SC_PlugIn.h>

#include "rdu.hpp"

static InterfaceTable *ft;

struct DustRange : public Unit {
	int32 mCounter;
};

void DustRange_next(DustRange *unit, int inNumSamples)
{
	float *out = OUT(0);
	GetInput getIotMin = genGet(unit, 0);
	GetInput getIotMax = genGet(unit, 1);
	RGen &rgen = *unit->mParent->mRGen;
	for (int32 i = 0; i < inNumSamples; i++) {
		if (unit->mCounter <= 0) {
			float z = rgen.frand();
			float wait = (z * (getIotMax(i) - getIotMin(i))) + getIotMin(i);
			out[i] = z;
			unit->mCounter = (int32)(wait * unit->mRate->mSampleRate);
		} else {
			out[i] = 0.0;
		}
		unit->mCounter -= 1;
	}
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
