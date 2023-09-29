#include <stdbool.h>
#include <stdio.h>

#include <SC_PlugIn.h>

static InterfaceTable *ft;

#define TrigAllocatorMax 24

struct TrigAllocator : public Unit {
    uint32 m_num_outputs;
    uint64 m_time;
    float m_trig;
    float m_gate[TrigAllocatorMax];
    bool m_in_use[TrigAllocatorMax];
    uint64 m_start_time[TrigAllocatorMax]; /* not used, allow for alternate algorithms */
    uint64 m_end_time[TrigAllocatorMax];
};

int TrigAllocator_locate_index(TrigAllocator *unit) {
    for(uint32 i = 0; i < unit->m_num_outputs; i++) {
	if(!unit->m_in_use[i]) {
	    return i;
	}
    }
    return -1;
}

void TrigAllocator_next(TrigAllocator *unit, int inNumSamples)
{
    // float *algorithm = IN(0); /* not used, allow for alternate algorithms */
    float *trig = IN(1);
    float *dur = IN(2);
    for(int i = 0; i < inNumSamples; i++) {
	unit->m_time += 1;
	for(uint32 j = 0; j < unit->m_num_outputs; j++) {
	    if(unit->m_in_use[j] && unit->m_end_time[j] <= unit->m_time) {
		unit->m_in_use[j] = false;
		unit->m_gate[j] = 0.0;
		fprintf(stderr, "TrigAllocator: free=%d, end=%ld, time=%ld\n", j, unit->m_end_time[j], unit->m_time);
	    }
	}
	if(trig[i] > 0.0 && unit->m_trig <= 0.0) {
	    int k = TrigAllocator_locate_index(unit);
	    if(k >= 0) {
		unit->m_gate[k] = trig[i];
		unit->m_in_use[k] = true;
		unit->m_start_time[k] = unit->m_time;
		unit->m_end_time[k] = unit->m_time + (uint32)(dur[i] * unit->mRate->mSampleRate);
		fprintf(stderr, "TrigAllocator: allocate=%d, end=%ld, time=%ld\n", k, unit->m_end_time[k], unit->m_time);
	    } else {
		fprintf(stderr, "TrigAllocator: no index located, time=%ld\n", unit->m_time);
	    }
	}
	unit->m_trig = trig[i];
	for(uint32 j = 0; j < unit->m_num_outputs; j++) {
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
    for (uint32 i = 0; i < unit->m_num_outputs; i++) {
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
