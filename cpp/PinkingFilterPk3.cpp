// Paul Kellet's refined method ; https://www.firstpr.com.au/dsp/pink-noise/ ; SampleRate=44100

#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct PinkingFilterPk3 : public Unit {
    float b0, b1, b2, b3, b4, b5, b6;
};

void PinkingFilterPk3_next(PinkingFilterPk3 *unit, int inNumSamples)
{
    float *in = IN(0);
    float *out = OUT(0);
    for (int i = 0; i < inNumSamples; i++) {
        float white = in[i];
        float pink;
        unit->b0 = (0.99886 * unit->b0) + (white * 0.0555179);
        unit->b1 = (0.99332 * unit->b1) + (white * 0.0750759);
        unit->b2 = (0.96900 * unit->b2) + (white * 0.1538520);
        unit->b3 = (0.86650 * unit->b3) + (white * 0.3104856);
        unit->b4 = (0.55000 * unit->b4) + (white * 0.5329522);
        unit->b5 = (-0.7616 * unit->b5) - (white * 0.0168980);
        pink = unit->b0 + unit->b1 + unit->b2 + unit->b3 + unit->b4 + unit->b5 + unit->b6 + (white * 0.5362);
        unit->b6 = white * 0.115926;
        out[i] = pink;
    }
}

void PinkingFilterPk3_Ctor(PinkingFilterPk3 *unit)
{
    unit->b0 = unit->b1 = unit->b2 = unit->b3 = unit->b4 = unit->b5 = unit->b6 = 0.0;
    SETCALC(PinkingFilterPk3_next);
    PinkingFilterPk3_next(unit, 1);
}

PluginLoad(PinkingFilterPk3)
{
    ft = inTable;
    DefineSimpleUnit(PinkingFilterPk3);
}
