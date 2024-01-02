#include <stdio.h>

#include <SC_PlugIn.h>

#include "r-common/c/print.h"

#include "rdu.hpp"

static InterfaceTable *ft;

struct DurationGate : public Unit {
	uint32_t dur;
	uint32_t count;
};

void DurationGate_next(DurationGate *unit, int inNumSamples)
{
	GetInput getDur = genGet(unit, 0);
	for (int i = 0; i < inNumSamples; i++) {
		if (unit->count == unit->dur) {
			unit->mOutBuf[0][i] = 0.0;
		} else if (unit->count > unit->dur) {
			unit->count = 0;
			unit->dur = (getDur(i) * unit->mRate->mSampleRate) - 1;
			if (unit->dur < 1) {
				unit->dur = 1;
			}
			dprintf("DurationGate: %f %f, %d\n", getDur(i), unit->dur);
			unit->mOutBuf[0][i] = 1.0;
		} else {
			unit->mOutBuf[0][i] = 1.0;
		}
		unit->count += 1;
	}
}

void DurationGate_Ctor(DurationGate *unit)
{
	unit->count = 0;
	unit->dur = 0;
	SETCALC(DurationGate_next);
	DurationGate_next(unit, 1);
}

PluginLoad(DurationGate)
{
	ft = inTable;
	DefineSimpleUnit(DurationGate);
}
