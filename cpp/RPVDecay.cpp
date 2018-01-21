#include <stdio.h>

#include <SC_fftlib.h>
#include <FFT_UGens.h>
#include <SCComplex.h>
#include <SC_PlugIn.h>

#include "rdu.h"

InterfaceTable *ft;

struct RPVDecayTbl:PV_Unit
{
    SndBuf *m_buf;                                /* fft */
    rdu_declare_buf(dr);                          /* decay rate */
    rdu_declare_buf(dl);                          /* dhistory (delay) */
};

rdu_prototypes(RPVDecayTbl);

void RPVDecayTbl_next(RPVDecayTbl * unit, int inNumSamples)
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
            printf("RPVDecayTbl: magnitude is negative\n");
            p->bin[i].mag = x;
        }
    }
}

void RPVDecayTbl_Ctor(RPVDecayTbl * unit)
{
    rdu_init_buf(dr);
    rdu_init_buf(dl);
    SETCALC(RPVDecayTbl_next);
    RPVDecayTbl_next(unit, 1);
}

void init_SCComplex(InterfaceTable * inTable);

PluginLoad(RPVTblDecay)
{
    ft = inTable;
    init_SCComplex(inTable);
    DefineSimpleUnit(RPVDecayTbl);
}
