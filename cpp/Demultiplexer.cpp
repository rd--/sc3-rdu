#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include <SC_PlugIn.h>

#include "rdu.hpp"

static InterfaceTable *ft;

#define DemultiplexerMax 32

struct Demultiplexer : public Unit {
	uint32_t m_num_outputs;
};

void Demultiplexer_next(Demultiplexer *unit, int inNumSamples)
{
	GetInput getInput = genGet(unit, 0);
	GetInput getSelector = genGet(unit, 1);
	for (int i = 0; i < inNumSamples; i++) {
		float out[DemultiplexerMax];
		uint32_t selected = (uint32_t)getSelector(i);
		if (selected < 0 || selected >= unit->m_num_outputs) {
			printf("Demultiplexer: selector invalid: %d\n", selected);
		}
		for (uint32_t j = 0; j < unit->m_num_outputs; j++) {
			if (j == selected) {
				out[j] = getInput(i);
			} else {
				out[j] = 0.0;
			}
		}
		/* Write outputs */
		for (uint32_t j = 0; j < unit->m_num_outputs; j++) {
			unit->mOutBuf[j][i] = out[j];
		}
	}
}

void Demultiplexer_Ctor(Demultiplexer *unit)
{
	unit->m_num_outputs = unit->mNumOutputs;
	if (unit->m_num_outputs > DemultiplexerMax) {
		unit->m_num_outputs = DemultiplexerMax;
		printf("Demultiplexer: output count limited %d\n", unit->m_num_outputs);
	}
	SETCALC(Demultiplexer_next);
	Demultiplexer_next(unit, 1);
}

PluginLoad(Demultiplexer)
{
	ft = inTable;
	DefineSimpleUnit(Demultiplexer);
}
