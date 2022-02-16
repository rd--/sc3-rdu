/* https://github.com/2DaT/Obxd */

#include "rdu.h" /* PI */

#define float_Pi (float)(PI)

#include "Obxd/Engine/AudioUtils.h"
#include "Obxd/Engine/Filter.h"

/* SC3 */
static InterfaceTable *ft;

struct ObxdFilter : public Unit
{
    Filter *m_flt;
};

void ObxdFilter_next(ObxdFilter *unit,int inNumSamples)
{
    float *in = IN(0);
    float *out = OUT(0);
    float cutoff = IN0(1);
    unit->m_flt->setResonance(IN0(2));
    unit->m_flt->setMultimode(IN0(3));
    unit->m_flt->bandPassSw = (bool)(IN0(4) > 0.5);
    bool four_pole = (bool)(IN0(5) > 0.5);
    if(four_pole) {
        for(int i = 0; i < inNumSamples; i++) {
            out[i] = unit->m_flt->Apply4Pole(in[i],cutoff);
        }
    } else {
        for(int i = 0; i < inNumSamples; i++) {
            out[i] = unit->m_flt->Apply(in[i],cutoff);
        }
    }
}

void ObxdFilter_Ctor(ObxdFilter *unit)
{
    unit->m_flt = new Filter;
    unit->m_flt->setSampleRate(SAMPLERATE);
    SETCALC(ObxdFilter_next);
    ObxdFilter_next(unit, 1);
}

void ObxdFilter_Dtor(ObxdFilter *unit)
{
    delete unit->m_flt;
}

PluginLoad(ObxdFilter)
{
    ft = inTable;
    DefineDtorUnit(ObxdFilter);
}
