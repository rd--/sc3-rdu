#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct TrigRoundRobin : public Unit {
    float m_trig;
    uint32_t m_last_index_allocated;
    float *m_out;
};

/* Note: In ScSynth input and output buffers may be reused. */
void TrigRoundRobin_next(TrigRoundRobin *unit, int inNumSamples)
{
    float *in = IN(0);
    for(int i = 0; i < inNumSamples; i++) {
	/* Zero outputs */
	for(uint32_t j = 0; j < unit->mNumOutputs; j++) {
	    unit->m_out[j] = 0.0;
	}
	/* On trigger step output index counter and set output */
	if(in[i] > 0.0 && unit->m_trig <= 0.0) {
	    uint32_t k = (unit->m_last_index_allocated + 1) % unit->mNumOutputs;
	    // fprintf(stderr, "TrigRoundRobin: i=%d k=%d in[i]=%f\n", i, k, in[i]);
	    unit->m_out[k] = in[i];
	    unit->m_last_index_allocated = k;
	}
	unit->m_trig = in[i];
	/* Write outputs */
	for(uint32_t j = 0; j < unit->mNumOutputs; j++) {
	    OUT(j)[i] = unit->m_out[j];
	}
    }
}

void TrigRoundRobin_Ctor(TrigRoundRobin *unit)
{
    unit->m_out = (float *)RTAlloc(unit->mWorld, unit->mNumOutputs * sizeof(float));
    unit->m_trig = 0.0;
    unit->m_last_index_allocated = -1;
    SETCALC(TrigRoundRobin_next);
    TrigRoundRobin_next(unit, 1);
}

void TrigRoundRobin_Dtor(TrigRoundRobin *unit)
{
    RTFree(unit->mWorld, unit->m_out);
}

PluginLoad(TrigRoundRobin)
{
    ft = inTable;
    DefineDtorUnit(TrigRoundRobin);
}
