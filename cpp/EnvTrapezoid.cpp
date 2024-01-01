#include <stdio.h>

#include <SC_PlugIn.h>

#include "r-common/c/gen-trapezoid.c"
#include "r-common/c/segment-transfer.c"

#include "rdu.hpp"

static InterfaceTable *ft;

struct EnvTrapezoid : public Unit {
	float trig;
	uint32_t dur;
	uint32_t count;
	float env[8];
};

void EnvTrapezoid_next(EnvTrapezoid *unit, int inNumSamples)
{
	float *trig = IN(0);
	GetInput getDur = genGet(unit, 1);
	GetInput getShape = genGet(unit, 2);
	GetInput getSkew = genGet(unit, 3);
	for (int i = 0; i < inNumSamples; i++) {
		if (trig[i] > 0.0 && unit->trig <= 0.0) {
			unit->count = 0;
			unit->dur = getDur(i) * unit->mRate->mSampleRate;
			// fprintf(stderr, "EnvTrapezoid: %f %f %f %f, %d\n", trig[i], getDur(i), getShape(i), getSkew(i), unit->dur);
			gen_trapezoid(unit->env, 8, 1, getShape(i), getSkew(i));
		}
		if (unit->count < unit->dur) {
			unit->mOutBuf[0][i] = segment_transfer_lookup_linear(
				unit->env,
				8,
				(float)(unit->count) / (float)(unit->dur));
		} else {
			unit->mOutBuf[0][i] = 0;
		}
		unit->count += 1;
		unit->trig = trig[i];
	}
}

void EnvTrapezoid_Ctor(EnvTrapezoid *unit)
{
	unit->trig = 0;
	unit->count = 0;
	unit->dur = 0;
	SETCALC(EnvTrapezoid_next);
	EnvTrapezoid_next(unit, 1);
}

PluginLoad(EnvTrapezoid)
{
	ft = inTable;
	DefineSimpleUnit(EnvTrapezoid);
}
