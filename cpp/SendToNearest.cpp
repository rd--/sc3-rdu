#include <float.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include "r-common/c/vector.c"

#include <SC_PlugIn.h>

static InterfaceTable *ft;

#define SendToNearestMax 64

/*
coordinateArray.size(Ir)=0 trig=1(Kr) x,y,z=2,3,4(Kr) ++ coordinateArray(Ir) ++ inputArray(Ar)
*/

struct SendToNearest : public Unit {
    uint32_t m_num_coordinates;
    uint32_t m_num_outputs;
    uint32_t m_prev_trig;
    v3 m_coordinates[SendToNearestMax];
    int m_indices[SendToNearestMax];
    float m_distances[SendToNearestMax];
};

bool SendToNearest_index_used(SendToNearest *unit, int index)
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

void SendToNearest_next(SendToNearest *unit, int inNumSamples)
{
    float trig = IN0(1);
    uint32_t input_index0 = 1 + 1 + 3 + (unit->m_num_coordinates * 3);
    v3 location = {IN0(2), IN0(3), IN0(4)};
    float distances[SendToNearestMax];
    if(trig > 0.0 && unit->m_prev_trig <= 0.0) {
	for(uint32_t i = 0; i < unit->m_num_coordinates; i++) {
	    distances[i] = v3_distance(location, unit->m_coordinates[i]);
	}
	for(uint32_t i = 0; i < unit->m_num_outputs; i++) {
	    unit->m_indices[i] = -1;
	    unit->m_distances[i] = FLT_MAX;
	}
	for(uint32_t i = 0; i < unit->m_num_outputs; i++) {
	    for(uint32_t j = 0; j < unit->m_num_coordinates; j++) {
		if((distances[j] < unit->m_distances[i]) && !SendToNearest_index_used(unit, j)) {
		    unit->m_indices[i] = j;
		    unit->m_distances[i] = distances[j];
		}
	    }
	}
	unit->m_prev_trig = trig;
    }
    for(int i = 0; i < inNumSamples; i++) {
	// float out[SendToNearestMax];
	for(uint32_t j = 0; j < unit->m_num_outputs; j++) {
	    OUT(unit->m_indices[j])[i] = IN(input_index0 + j)[i];
	}
    }
}

void SendToNearest_Ctor(SendToNearest *unit)
{
    unit->m_num_coordinates = IN0(0);
    unit->m_num_outputs = unit->mNumOutputs;
    if(unit->m_num_outputs > SendToNearestMax) {
	unit->m_num_outputs = SendToNearestMax;
        fprintf(stderr, "SendToNearest: output count limited %d\n", unit->m_num_outputs);
    }
    SETCALC(SendToNearest_next);
    SendToNearest_next(unit, 1);
}

PluginLoad(SendToNearest)
{
    ft = inTable;
    DefineSimpleUnit(SendToNearest);
}
