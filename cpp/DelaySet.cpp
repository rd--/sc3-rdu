#include <stdio.h>

#include <SC_PlugIn.h>

#include "r-common/c/cq.c"
#include "r-common/c/signal-interpolate.c"

#include "DelaySet.h"
#include "rdu.h"

static InterfaceTable *ft;

struct DelaySet : public Unit {
	delayset_struct_common;
};

void DelaySet_next(DelaySet *unit, int inNumSamples)
{
	delayset_next_common(0);
}

void DelaySet_Ctor(DelaySet *unit)
{
	delayset_ctor_common(1);
	try {
		unit->m_signal = (float *)RTAlloc(unit->mWorld,
			unit->m_signal_n * sizeof(float));
		memset((void *)unit->m_signal, 0, unit->m_signal_n * sizeof(float));
	} catch (...) {
		printf("DelaySet_Ctor: RTAlloc failed...\n");
		unit->m_tap_n = 0;
	}
	SETCALC(DelaySet_next);
	DelaySet_next(unit, 1);
}

void DelaySet_Dtor(DelaySet *unit)
{
	RTFree(unit->mWorld, unit->m_signal);
}

rdu_load_dtor(DelaySet)
