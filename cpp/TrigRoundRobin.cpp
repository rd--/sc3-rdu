#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include <SC_PlugIn.h>

static InterfaceTable *ft;

#define TrigRoundRobinMax 32

struct TrigRoundRobin : public Unit {
    uint32_t m_num_outputs;
    float m_trig;
    uint32_t m_last_index_allocated;
};

/* Note: In ScSynth input and output buffers may be reused. */
void TrigRoundRobin_next(TrigRoundRobin *unit, int inNumSamples)
{
    float *in = IN(0);
    for(int i = 0; i < inNumSamples; i++) {
	float out[TrigRoundRobinMax];
	/* Zero outputs */
	for(uint32_t j = 0; j < unit->m_num_outputs; j++) {
	    out[j] = 0.0;
	}
	/* On trigger step output index counter and set output */
	if(in[i] > 0.0 && unit->m_trig <= 0.0) {
	    uint32_t k = (unit->m_last_index_allocated + 1) % unit->m_num_outputs;
	    // fprintf(stderr, "TrigRoundRobin: i=%d k=%d in[i]=%f\n", i, k, in[i]);
	    out[k] = in[i];
	    unit->m_last_index_allocated = k;
	}
	unit->m_trig = in[i];
	/* Write outputs */
	for(uint32_t j = 0; j < unit->m_num_outputs; j++) {
	    OUT(j)[i] = out[j];
	}
    }
}

void TrigRoundRobin_Ctor(TrigRoundRobin *unit)
{
    unit->m_num_outputs = unit->mNumOutputs;
    if(unit->m_num_outputs > TrigRoundRobinMax) {
	unit->m_num_outputs = TrigRoundRobinMax;
        fprintf(stderr, "TrigRoundRobin: output count limited %d\n", unit->m_num_outputs);
    }
    unit->m_trig = 0.0;
    unit->m_last_index_allocated = -1;
    SETCALC(TrigRoundRobin_next);
    TrigRoundRobin_next(unit, 1);
}

PluginLoad(TrigRoundRobin)
{
    ft = inTable;
    DefineSimpleUnit(TrigRoundRobin);
}
