#include <stdlib.h> // qsort

#include <SC_PlugIn.h>

#include "r-common/c/compare.h"

static InterfaceTable *ft;

struct TSort : public Unit {
    float *m_store;
    float m_prev_t;
};

void TSort_step(TSort *unit)
{
    float *d = unit->m_store;
    int k = unit->mNumInputs - 1;
    for (int i = 0; i < k; i++) {
        d[i] = IN0(i + 1);
    }
    qsort(d, k, sizeof(float), compare_float);
}

void TSort_next(TSort *unit, int inNumSamples)
{
    float *in = IN(0);
    int k = unit->mNumInputs - 1;
    for (int i = 0; i < inNumSamples; i++) {
        float t = in[i];
        if (t > 0.0 && unit->m_prev_t <= 0.0) {
            TSort_step(unit);
        }
        for (int j = 0; j < k; j++) {
            OUT(j)[i] = unit->m_store[j];
        }
        unit->m_prev_t = t;
    }
}

void TSort_Ctor(TSort *unit)
{
    int k = unit->mNumInputs - 1;
    unit->m_store = (float *)RTAlloc(unit->mWorld, k * sizeof(float));
    unit->m_prev_t = 0;
    SETCALC(TSort_next);
    for (int i = 0; i < k; i++) {
        unit->m_store[i] = IN0(i + 1);
    }
    TSort_next(unit, 1);
}

void TSort_Dtor(TSort *unit)
{
    RTFree(unit->mWorld, unit->m_store);
}

PluginLoad(TSort)
{
    ft = inTable;
    DefineDtorUnit(TSort);
}
