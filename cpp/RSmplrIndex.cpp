#include <stdio.h>

#include <SC_PlugIn.h>

#include "rdu.h"

static InterfaceTable *ft;

struct RSmplrIndex : public Unit
{
    rdu_declare_buf(tbl);
    float m_mnn;
    float m_index;
    float m_mul;
};

float midi_to_ratio(float mnn)
{
    return powf(2.0,mnn * (1.0 / 12.0));
}

float midi_diff_to_ratio(float mnn0,float mnn1)
{
    return midi_to_ratio(mnn1 - mnn0);
}

void RSmplrIndex_next(RSmplrIndex* unit, int inNumSamples)
{
    rdu_get_buf(tbl,0);
    rdu_check_buf(tbl,1);
    int tbl_n = (int) IN0(1);
    float mnn = IN0(2);
    int index = 0;
    if (mnn != unit->m_mnn) {
        for(index = 0; index < tbl_n - 1 ; index++) {
            if(mnn >= unit->m_buf_tbl->data[index] && mnn < unit->m_buf_tbl->data[index + 1]) {
                break;
            }
        }
        unit->m_mnn = mnn;
        unit->m_index = (float)index;
        unit->m_mul = midi_diff_to_ratio(mnn,unit->m_buf_tbl->data[index]);
    }
    OUT0(0) = unit->m_index;
    OUT0(1) = unit->m_mul;
}

void RSmplrIndex_Ctor(RSmplrIndex* unit)
{
    rdu_init_buf(tbl);
    unit->m_mnn = 0.0;
    unit->m_index = 0.0;
    unit->m_mul = 1.0;
    SETCALC(RSmplrIndex_next);
    RSmplrIndex_next(unit, 1);
}

PluginLoad(RSmplrIndex)
{
  ft = inTable;
  DefineSimpleUnit(RSmplrIndex);
}
