#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include <SC_PlugIn.h>

static InterfaceTable *ft;

#define DemultiplexerMax 32

struct Demultiplexer : public Unit {
    uint32_t m_num_outputs;
};

void Demultiplexer_next(Demultiplexer *unit, int inNumSamples)
{
    float *input = IN(0);
    float *selector = IN(1);
    for(int i = 0; i < inNumSamples; i++) {
	float out[DemultiplexerMax];
	uint32_t selected = (uint32_t)selector[i];
	if(selected < 0 || selected >= unit->m_num_outputs) {
	    selected = 0;
	}
	for(uint32_t j = 0; j < unit->m_num_outputs; j++) {
	    if(j == selected) {
		out[j] = input[i];
	    } else {
		out[j] = 0.0;
	    }
	}
	/* Write outputs */
	for(uint32_t j = 0; j < unit->m_num_outputs; j++) {
	    OUT(j)[i] = out[j];
	}
    }
}

void Demultiplexer_Ctor(Demultiplexer *unit)
{
    unit->m_num_outputs = unit->mNumOutputs;
    if(unit->m_num_outputs > DemultiplexerMax) {
	unit->m_num_outputs = DemultiplexerMax;
    }
    SETCALC(Demultiplexer_next);
    Demultiplexer_next(unit, 1);
}

PluginLoad(Demultiplexer)
{
    ft = inTable;
    DefineSimpleUnit(Demultiplexer);
}
