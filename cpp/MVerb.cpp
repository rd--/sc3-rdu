#include <SC_PlugIn.h>

namespace Eastwood {
#include "MVerb.h"
}

static InterfaceTable *ft;

#define MVerbNumCtl 9

struct MVerb : public Unit {
	Eastwood::MVerb<float> *mverb;
	float ctl[MVerbNumCtl]; // control inputs, previous values
};

void MVerb_next(MVerb *unit, int inNumSamples)
{
	float **in = unit->mInBuf; // two-channels
	float **out = unit->mOutBuf; // two-channels
	float c[MVerbNumCtl];
	for (int i = 0; i < MVerbNumCtl; i++) {
		c[i] = IN0(i + 2);
		if (c[i] != unit->ctl[i]) {
			unit->mverb->setParameter(i, c[i]);
			unit->ctl[i] = c[i];
		}
	}
	unit->mverb->process(in, out, inNumSamples);
}

void MVerb_Ctor(MVerb *unit)
{
	unit->mverb = new (Eastwood::MVerb<float>);
	unit->mverb->setSampleRate((float)(unit->mRate->mSampleRate));
	for (int i = 0; i < MVerbNumCtl; i++) {
		unit->ctl[i] = -1.0; // non-allowed value (0-1)
	}
	SETCALC(MVerb_next);
	MVerb_next(unit, 1);
}

void MVerb_Dtor(MVerb *unit)
{
	delete unit->mverb;
}

PluginLoad(MVerb)
{
	ft = inTable;
	DefineDtorUnit(MVerb);
}
