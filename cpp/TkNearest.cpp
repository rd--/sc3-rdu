#include <float.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include "r-common/c/print.h"
#include "r-common/c/vector.c"

#include <SC_PlugIn.h>

static InterfaceTable *ft;

#define TkNearestMax 64

struct TkNearest : public Unit {
    uint32_t m_num_coordinates;
    uint32_t m_num_outputs;
    float m_prev_trig;
    int m_indices[TkNearestMax];
};

bool TkNearest_is_index_used(TkNearest *unit, int index)
{
    for(uint32_t i = 0; i < unit->m_num_outputs; i++) {
	if(unit->m_indices[i] == -1) {
	    return false;
	} else if(unit->m_indices[i] == index) {
	    return true;
	}
    }
    return false;
}

void TkNearest_next(TkNearest *unit, int inNumSamples)
{
    float trig = IN0(0);
    if(trig > 0.0 && unit->m_prev_trig <= 0.0) {
	v3 location = {IN0(1), IN0(2), IN0(3)};
	v3 coordinates[TkNearestMax];
	float distances[TkNearestMax];
	dprintf("TkNearest\n");
	dprintf("  trigger > 0 = %f,%f\n", trig, unit->m_prev_trig);
	dprintf("  m_num_coordinates=%d\n", unit->m_num_coordinates);
	dprintf("  m_num_outputs=%d\n", unit->m_num_outputs);
	dprintf("  trigger = %f,%f\n", trig, unit->m_prev_trig);
	dprintf("  location = (%f,%f,%f)\n", IN0(1), IN0(2), IN0(3));
        for (uint32_t i = 0; i < unit->m_num_coordinates; i++) {
	    coordinates[i] = {IN0(4 + (i * 3)), IN0(5 + (i * 3)), IN0(6 + (i * 3))};
	    dprintf("  coordinates[%d] = (%f,%f,%f)\n", i,
		    IN0(4 + (i * 3)), IN0(5 + (i * 3)), IN0(6 + (i * 3)));
        }
	for(uint32_t i = 0; i < unit->m_num_coordinates; i++) {
	    distances[i] = v3_distance(location, coordinates[i]);
	    dprintf("  distances[%d] = %f\n", i, distances[i]);
	}
	for(uint32_t i = 0; i < unit->m_num_outputs; i++) {
	    unit->m_indices[i] = -1;
	}
	for(uint32_t i = 0; i < unit->m_num_outputs; i++) {
	    float current_distance = FLT_MAX;
	    for(uint32_t j = 0; j < unit->m_num_coordinates; j++) {
		if((distances[j] < current_distance) && !TkNearest_is_index_used(unit, j)) {
		    unit->m_indices[i] = j;
		    current_distance = distances[j];
		    dprintf("  improved: i=%d, j=%d, d=%f\n", i, j, distances[j]);
		}
	    }
	}
    }
    unit->m_prev_trig = trig;
    for(int i = 0; i < inNumSamples; i++) {
	for(uint32_t j = 0; j < unit->m_num_outputs; j++) {
	    OUT(j)[i] = unit->m_indices[j];
	}
    }
}

void TkNearest_Ctor(TkNearest *unit)
{
    unit->m_num_coordinates = (unit->mNumInputs - 4) / 3;
    if(unit->m_num_coordinates > TkNearestMax) {
	unit->m_num_coordinates = TkNearestMax;
        printf("TkNearest: coordinate count limited %d\n", unit->m_num_coordinates);
    }
    unit->m_num_outputs = unit->mNumOutputs;
    if(unit->m_num_outputs > TkNearestMax) {
	unit->m_num_outputs = TkNearestMax;
        printf("TkNearest: output count limited %d\n", unit->m_num_outputs);
    }
    unit->m_prev_trig = -1;
    for(uint32_t i = 0; i < unit->m_num_outputs; i++) {
	unit->m_indices[i] = 0;
    }
    SETCALC(TkNearest_next);
    TkNearest_next(unit, 1);
}

PluginLoad(TkNearest)
{
    ft = inTable;
    DefineSimpleUnit(TkNearest);
}
