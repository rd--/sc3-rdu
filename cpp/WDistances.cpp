#include <float.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include "r-common/c/print.h"
#include "r-common/c/vector.c"

#include <SC_PlugIn.h>

static InterfaceTable *ft;

#define WDistancesMax 64

struct WDistances : public Unit {
    uint32_t m_num_outputs;
    float m_distances[WDistancesMax];
};

void WDistances_next(WDistances *unit, int inNumSamples)
{
    if(IN0(0) > 0.0) {
	v3 location = {IN0(1), IN0(2), IN0(3)};
	dprintf("WDistances\n");
	dprintf("  m_num_outputs=%d\n", unit->m_num_outputs);
	dprintf("  location = (%f,%f,%f)\n", IN0(1), IN0(2), IN0(3));
        for (uint32_t i = 0; i < unit->m_num_outputs; i++) {
	    v3 coordinate = {IN0(4 + (i * 3)), IN0(5 + (i * 3)), IN0(6 + (i * 3))};
	    unit->m_distances[i] = v3_distance(location, coordinate);
	    dprintf("  distance = %i,%f\n", i, unit->m_distances[i]);
	}
    }
    for(int i = 0; i < inNumSamples; i++) {
	for(uint32_t j = 0; j < unit->m_num_outputs; j++) {
	    OUT(j)[i] = unit->m_distances[j];
	}
    }
}

void WDistances_Ctor(WDistances *unit)
{
    unit->m_num_outputs = (unit->mNumInputs - 4) / 3;
    if(unit->m_num_outputs > WDistancesMax) {
	unit->m_num_outputs = WDistancesMax;
        printf("WDistances: coordinate count limited %d\n", unit->m_num_outputs);
    }
    for(uint32_t i = 0; i < unit->m_num_outputs; i++) {
	unit->m_distances[i] = 1.0;
    }
    SETCALC(WDistances_next);
    WDistances_next(unit, 1);
}

PluginLoad(WDistances)
{
    ft = inTable;
    DefineSimpleUnit(WDistances);
}
