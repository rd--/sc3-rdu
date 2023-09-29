#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include <SC_PlugIn.h>

static InterfaceTable *ft;

#define TrigAllocatorMax 24

struct TrigAllocator : public Unit {
    uint32_t m_num_outputs;
    uint64_t m_time;
    float m_trig;
    float m_gate[TrigAllocatorMax];
    bool m_in_use[TrigAllocatorMax];
    uint64_t m_start_time[TrigAllocatorMax];
    uint64_t m_end_time[TrigAllocatorMax];
};

bool TrigAllocator_locate_index(TrigAllocator *unit, int algorithm, int *index) {
    for(uint32_t i = 0; i < unit->m_num_outputs; i++) {
	if(!unit->m_in_use[i]) {
	    *index = (int)i;
	    return false;
	}
    }
    if(algorithm == 1) {
	uint64_t earliest_end_time = UINT64_MAX;
	for(uint32_t i = 0; i < unit->m_num_outputs; i++) {
	    if(unit->m_end_time[i] < earliest_end_time) {
		earliest_end_time = unit->m_end_time[i];
		*index = i;
	    }
	}
	return true;
    }
    if(algorithm == 2) {
	uint64_t earliest_start_time = UINT64_MAX;
	for(uint32_t i = 0; i < unit->m_num_outputs; i++) {
	    if(unit->m_start_time[i] < earliest_start_time) {
		earliest_start_time = unit->m_start_time[i];
		*index = i;
	    }
	}
	return true;
    }
    return false;
}

void TrigAllocator_next(TrigAllocator *unit, int inNumSamples)
{
    float *algorithm = IN(0);
    float *trig = IN(1);
    float *dur = IN(2);
    for(int i = 0; i < inNumSamples; i++) {
	unit->m_time += 1;
	for(uint32_t j = 0; j < unit->m_num_outputs; j++) {
	    if(unit->m_gate[j] < 0.0) {
		unit->m_gate[j] = -1.0 - unit->m_gate[j];
	    }
	    if(unit->m_in_use[j] && unit->m_end_time[j] <= unit->m_time) {
		unit->m_in_use[j] = false;
		unit->m_gate[j] = 0.0;
		// fprintf(stderr, "TrigAllocator: free=%d, end=%ld, time=%ld\n", j, unit->m_end_time[j], unit->m_time);
	    }
	}
	if(trig[i] > 0.0 && unit->m_trig <= 0.0) {
	    int k = -1;
	    bool stolen = TrigAllocator_locate_index(unit, (int)(algorithm[i]), &k);
	    if(k >= 0) {
		unit->m_gate[k] = stolen ? (-1.0 - trig[i]) : trig[i];
		unit->m_in_use[k] = true;
		unit->m_start_time[k] = unit->m_time;
		unit->m_end_time[k] = unit->m_time + (uint32_t)(dur[i] * unit->mRate->mSampleRate);
		// fprintf(stderr, "TrigAllocator: allocate=%d, stolen=%d, end=%ld, time=%ld\n", k, (int)stolen, unit->m_end_time[k], unit->m_time);
	    } else {
		// fprintf(stderr, "TrigAllocator: no index located: stolen=%d time=%ld\n", (int)stolen, unit->m_time);
	    }
	}
	unit->m_trig = trig[i];
	for(uint32_t j = 0; j < unit->m_num_outputs; j++) {
	    OUT(j)[i] = unit->m_gate[j];
	}
    }
}

void TrigAllocator_Ctor(TrigAllocator *unit)
{
    unit->m_num_outputs = unit->mNumOutputs;
    if(unit->m_num_outputs > TrigAllocatorMax) {
	unit->m_num_outputs = TrigAllocatorMax;
    }
    unit->m_time = 0;
    unit->m_trig = 0;
    for (uint32_t i = 0; i < unit->m_num_outputs; i++) {
        unit->m_gate[i] = 0.0;
        unit->m_in_use[i] = false;
        unit->m_start_time[i] = 0;
        unit->m_end_time[i] = 0;
    }
    SETCALC(TrigAllocator_next);
    TrigAllocator_next(unit, 1);
}

PluginLoad(TrigAllocator)
{
    ft = inTable;
    DefineSimpleUnit(TrigAllocator);
}
