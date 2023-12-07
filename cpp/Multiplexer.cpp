#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct Multiplexer : public Unit {
};

void Multiplexer_next(Multiplexer *unit, int inNumSamples)
{
	float *selector = IN(0);
	uint32_t inputCount = unit->mNumInputs - 1;
	for (int i = 0; i < inNumSamples; i++) {
		uint32_t selected = (uint32_t)selector[i];
		if (selected < 0 || selected >= inputCount) {
			fprintf(stderr, "Multiplexer: selector invalid: %d\n", selected);
		} else {
			OUT(0)
			[i] = IN(selected + 1)[i];
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
