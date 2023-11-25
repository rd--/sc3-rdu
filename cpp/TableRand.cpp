#include <stdio.h>

#include <SC_PlugIn.h>

#include "rdu.h"

static InterfaceTable *ft;

struct TableRand : public Unit {
    rdu_declare_buf(table);
    float m_trig;
    float m_store;
};

float clipAt(float *array, int size, int index)
{
    if(index >= size) {
	return array[size - 1];
    } else if(index < 0) {
	return array[0];
    } else {
	return array[index];
    }
}

float blend(float left, float right, float blendFrac)
{
    return (left + (blendFrac * (right - left)));
}

float blendAt(float *array, int size, float index)
{
    float indexMin = ceilf(index) - 1;
    return blend(
	clipAt(array, size, (int)indexMin),
	clipAt(array, size, (int)(indexMin + 1)),
	fabs(index - indexMin)
    );
}

void TableRand_next_k(TableRand *unit, int inNumSamples)
{
    float trig = IN0(0);
    if (trig > 0.f && unit->m_trig <= 0.f) {
	rdu_get_buf(table, 1);
	rdu_check_buf(table, 1);
	RGen &rgen = *unit->mParent->mRGen;
	unit->m_store = blendAt(
	    unit->m_buf_table->data,
	    unit->m_buf_table->frames,
	    rgen.frand() * (unit->m_buf_table->frames - 1)
        );
    }
    OUT0(0) = unit->m_store;
    unit->m_trig = trig;
}

void TableRand_Ctor(TableRand *unit)
{
    rdu_init_buf(table);
    SETCALC(TableRand_next_k);
    unit->m_trig = 0;
    TableRand_next_k(unit, 1);
}

PluginLoad(TableRand)
{
    ft = inTable;
    DefineSimpleUnit(TableRand);
}
