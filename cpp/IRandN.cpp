#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct IRandN : public Unit { };

void IRandN_Ctor(IRandN *unit)
{
	int lo = (int)IN0(0);
	int hi = (int)IN0(1);
	int range = hi - lo + 1;
	uint32 nc = unit->mNumOutputs;
	RGen &rgen = *unit->mParent->mRGen;
	uint32 i;
	for (i = 0; i < nc; i++) {
		OUT0(i) = (float)(rgen.irand(range) + lo);
	}
}

PluginLoad(IRandN)
{
	ft = inTable;
	DefineSimpleUnit(IRandN);
}
