#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include <SC_PlugIn.h>

#include "rdu.hpp"

static InterfaceTable *ft;

struct Multiplexer : public Unit {
};

void Multiplexer_next(Multiplexer *unit, int inNumSamples)
{
	GetInput getSelector = genGet(unit, 0);
	uint32_t inputCount = unit->mNumInputs - 1;
	for (int i = 0; i < inNumSamples; i++) {
		uint32_t selected = (uint32_t)getSelector(i);
		if (selected < 0 || selected >= inputCount) {
			printf("Multiplexer: selector invalid: %d\n", selected);
		} else {
			unit->mOutBuf[0][i] = getInput(unit, selected + 1, i);
		}
	}
}

void Multiplexer_Ctor(Multiplexer *unit)
{
	SETCALC(Multiplexer_next);
	Multiplexer_next(unit, 1);
}

PluginLoad(Multiplexer)
{
	ft = inTable;
	DefineSimpleUnit(Multiplexer);
}
