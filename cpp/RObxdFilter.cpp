/* https://github.com/2DaT/Obxd */

#include <math.h>

#include <SC_PlugIn.h>

#define float_Pi (float)(M_PI)

#include "Obxd/Engine/AudioUtils.h"
#include "Obxd/Engine/Filter.h"

#include "rdu.h"

/* SC3 */
static InterfaceTable *ft;

struct RObxdFilter : public Unit
{
    Filter *m_flt;
};

rdu_prototypes_dtor(RObxdFilter);

void RObxdFilter_Ctor(RObxdFilter *unit)
{
    unit->m_flt = new Filter;
    unit->m_flt->setSampleRate(SAMPLERATE);
    SETCALC(RObxdFilter_next);
    RObxdFilter_next(unit, 1);
}

void RObxdFilter_next(RObxdFilter *unit,int inNumSamples)
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

void RObxdFilter_Dtor(RObxdFilter *unit)
{
    delete unit->m_flt;
}

rdu_load_dtor(RObxdFilter);
