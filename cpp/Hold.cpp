#include <stdio.h>

#include <SC_PlugIn.h>

#include "rdu.hpp"

#include "r-common/c/print.h"

static InterfaceTable *ft;

struct Hold : public Unit {
	uint32_t dur;
	uint32_t count;
	float output;
};

void Hold_next(Hold *unit, int inNumSamples)
{
	float *in = IN(0);
	GetInput getDur = genGet(unit, 1);
	for (int i = 0; i < inNumSamples; i++) {
		if (unit->count >= unit->dur) {
			unit->count = 0;
			unit->dur = getDur(i) * unit->mRate->mSampleRate;
			unit->output = in[i];
			dprintf("Hold: %f %f, %d\n", unit->output, getDur(i), unit->dur);
		}
		unit->count += 1;
		unit->mOutBuf[0][i] = unit->output;
	}
}

void Hold_Ctor(Hold *unit)
{
	unit->count = 0;
	unit->dur = 0;
	SETCALC(Hold_next);
	Hold_next(unit, 1);
}

PluginLoad(Hold)
{
	ft = inTable;
	DefineSimpleUnit(Hold);
}
