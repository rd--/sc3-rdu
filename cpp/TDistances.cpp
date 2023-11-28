#include <float.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include "r-common/c/print.h"
#include "r-common/c/vector.c"

#include <SC_PlugIn.h>

static InterfaceTable *ft;

#define TDistancesMax 64

struct TDistances : public Unit {
    uint32_t m_num_outputs;
    float m_prev_trig;
    float m_distances[TDistancesMax];
};

void TDistances_next(TDistances *unit, int inNumSamples)
{
    float trig = IN0(0);
    if(trig > 0.0 && unit->m_prev_trig <= 0.0) {
	v3 location = {IN0(1), IN0(2), IN0(3)};
	dprintf("TDistances\n");
	dprintf("  trigger > 0 = %f,%f\n", trig, unit->m_prev_trig);
	dprintf("  m_num_outputs=%d\n", unit->m_num_outputs);
	dprintf("  trigger = %f,%f\n", trig, unit->m_prev_trig);
	dprintf("  location = (%f,%f,%f)\n", IN0(1), IN0(2), IN0(3));
        for (uint32_t i = 0; i < unit->m_num_outputs; i++) {
	    v3 coordinate = {IN0(4 + (i * 3)), IN0(5 + (i * 3)), IN0(6 + (i * 3))};
	    unit->m_distances[i] = v3_distance(location, coordinate);
	    dprintf("  distance = %i,%f\n", i, unit->m_distances[i]);
	}
    }
    unit->m_prev_trig = trig;
    for(int i = 0; i < inNumSamples; i++) {
	for(uint32_t j = 0; j < unit->m_num_outputs; j++) {
	    OUT(j)[i] = unit->m_distances[j];
	}
    }
}

void TDistances_Ctor(TDistances *unit)
{
    unit->m_num_outputs = (unit->mNumInputs - 4) / 3;
    if(unit->m_num_outputs > TDistancesMax) {
	unit->m_num_outputs = TDistancesMax;
        printf("TDistances: coordinate count limited %d\n", unit->m_num_outputs);
    }
    unit->m_prev_trig = -1;
    for(uint32_t i = 0; i < unit->m_num_outputs; i++) {
	unit->m_distances[i] = 1.0;
    }
    SETCALC(TDistances_next);
    TDistances_next(unit, 1);
}

PluginLoad(TDistances)
{
    ft = inTable;
    DefineSimpleUnit(TDistances);
}
