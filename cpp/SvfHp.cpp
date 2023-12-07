// https://kokkinizita.linuxaudio.org/papers/digsvfilt.pdf

#include <SC_PlugIn.h>

#include "r-common/c/svf.c"

static InterfaceTable *ft;

struct SvfHp : public Unit {
	float m_z1, m_z2;
};

void SvfHp_next(SvfHp *unit, int inNumSamples)
{
	float *in = IN(0);
	float f = IN0(1) / unit->mRate->mSampleRate;
	float q = IN0(2) > 0.0001 ? IN0(2) : 0.0001;
	float *out = OUT(0);
	float z1 = unit->m_z1;
	float z2 = unit->m_z2;
	float c1;
	float c2;
	svf_calculate_c1_and_c2(f, q, &c1, &c2);
	float d0 = 1.0 - c1 / 2.0 + c1 * c2 / 4.0;
	for (int i = 0; i < inNumSamples; i++) {
		float x = in[i] - z1 - z2;
		out[i] = d0 * x;
		z2 += c2 * z1;
		z1 += c1 * x;
	}
	unit->m_z1 = z1;
	unit->m_z2 = z2;
}

void SvfHp_Ctor(SvfHp *unit)
{
	unit->m_z1 = 0.0;
	unit->m_z2 = 0.0;
	SETCALC(SvfHp_next);
	SvfHp_next(unit, 1);
}

PluginLoad(SvfHp)
{
	ft = inTable;
	DefineSimpleUnit(SvfHp);
}
