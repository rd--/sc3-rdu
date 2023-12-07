#include <stdio.h>

#include <FFT_UGens.h>
#include <SCComplex.h>
#include <SC_PlugIn.h>
#include <SC_fftlib.h>

#include "rdu.h"

InterfaceTable *ft;

struct PV_DecayTable : PV_Unit {
	SndBuf *m_buf; /* fft */
	rdu_declare_buf(dr); /* decay rate */
	rdu_declare_buf(dl); /* dhistory (delay) */
};

void PV_DecayTable_next(PV_DecayTable *unit, int inNumSamples)
{
	PV_GET_BUF
	rdu_get_buf(dr, 1);
	rdu_get_buf(dl, 2);
	rdu_check_buf(dr, 1);
	rdu_check_buf(dl, 1);
	SCPolarBuf *p = ToPolarApx(buf);
	for (int i = 0; i < numbins; i++) {
		float x = p->bin[i].mag;
		float x_dr = unit->m_buf_dr->data[i];
		float x_dl = unit->m_buf_dl->data[i];
		float x_nx = x > x_dl ? x : x_dl;
		unit->m_buf_dl->data[i] = x_nx * x_dr;
		p->bin[i].mag = x_nx;
		if (x < 0) {
			printf("PV_DecayTable: magnitude is negative\n");
			p->bin[i].mag = x;
		}
	}
}

void PV_DecayTable_Ctor(PV_DecayTable *unit)
{
	rdu_init_buf(dr);
	rdu_init_buf(dl);
	SETCALC(PV_DecayTable_next);
	PV_DecayTable_next(unit, 1);
}

void init_SCComplex(InterfaceTable *inTable);

PluginLoad(PV_DecayTable)
{
	ft = inTable;
	init_SCComplex(inTable);
	DefineSimpleUnit(PV_DecayTable);
}
