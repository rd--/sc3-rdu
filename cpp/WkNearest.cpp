#include <float.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include "r-common/c/print.h"
#include "r-common/c/vector.c"

#include <SC_PlugIn.h>

static InterfaceTable *ft;

#define WkNearestMax 64

struct WkNearest : public Unit {
	uint32_t m_num_coordinates;
	uint32_t m_num_outputs;
	int m_indices[WkNearestMax];
};

bool WkNearest_is_index_used(WkNearest *unit, int index)
{
	for (uint32_t i = 0; i < unit->m_num_outputs; i++) {
		if (unit->m_indices[i] == -1) {
			return false;
		} else if (unit->m_indices[i] == index) {
			return true;
		}
	}
	return false;
}

void WkNearest_next(WkNearest *unit, int inNumSamples)
{
	if (IN0(0) > 0.0) {
		v3 location = { IN0(1), IN0(2), IN0(3) };
		v3 coordinates[WkNearestMax];
		float distances[WkNearestMax];
		dprintf("WkNearest\n");
		dprintf("  m_num_coordinates=%d\n", unit->m_num_coordinates);
		dprintf("  m_num_outputs=%d\n", unit->m_num_outputs);
		dprintf("  location = (%f,%f,%f)\n", IN0(1), IN0(2), IN0(3));
		for (uint32_t i = 0; i < unit->m_num_coordinates; i++) {
			coordinates[i] = { IN0(4 + (i * 3)), IN0(5 + (i * 3)), IN0(6 + (i * 3)) };
			dprintf("  coordinates[%d] = (%f,%f,%f)\n", i,
				IN0(4 + (i * 3)), IN0(5 + (i * 3)), IN0(6 + (i * 3)));
		}
		for (uint32_t i = 0; i < unit->m_num_coordinates; i++) {
			distances[i] = v3_distance(location, coordinates[i]);
			dprintf("  distances[%d] = %f\n", i, distances[i]);
		}
		for (uint32_t i = 0; i < unit->m_num_outputs; i++) {
			unit->m_indices[i] = -1;
		}
		for (uint32_t i = 0; i < unit->m_num_outputs; i++) {
			float current_distance = FLT_MAX;
			for (uint32_t j = 0; j < unit->m_num_coordinates; j++) {
				if ((distances[j] < current_distance) && !WkNearest_is_index_used(unit, j)) {
					unit->m_indices[i] = j;
					current_distance = distances[j];
					dprintf("  improved: i=%d, j=%d, d=%f\n", i, j, distances[j]);
				}
			}
		}
	}
	for (int i = 0; i < inNumSamples; i++) {
		for (uint32_t j = 0; j < unit->m_num_outputs; j++) {
			unit->mOutBuf[j][i] = unit->m_indices[j];
		}
	}
}

void WkNearest_Ctor(WkNearest *unit)
{
	unit->m_num_coordinates = (unit->mNumInputs - 4) / 3;
	if (unit->m_num_coordinates > WkNearestMax) {
		unit->m_num_coordinates = WkNearestMax;
		printf("WkNearest: coordinate count limited %d\n", unit->m_num_coordinates);
	}
	unit->m_num_outputs = unit->mNumOutputs;
	if (unit->m_num_outputs > WkNearestMax) {
		unit->m_num_outputs = WkNearestMax;
		printf("WkNearest: output count limited %d\n", unit->m_num_outputs);
	}
	for (uint32_t i = 0; i < unit->m_num_outputs; i++) {
		unit->m_indices[i] = 0;
	}
	SETCALC(WkNearest_next);
	WkNearest_next(unit, 1);
}

PluginLoad(WkNearest)
{
	ft = inTable;
	DefineSimpleUnit(WkNearest);
}
