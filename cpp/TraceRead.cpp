#include <stdio.h>

#include <SC_PlugIn.h>

#include "r-common/c/trace.c"

#include "rdu.h"

static InterfaceTable *ft;

struct TraceRead : public Unit
{
  rdu_declare_buf(tr);
};

rdu_prototypes(TraceRead)

void TraceRead_Ctor(TraceRead *unit)
{
  rdu_init_buf(tr);
  SETCALC(TraceRead_next);
  TraceRead_next(unit,1);
}

void TraceRead_next(TraceRead *unit, int inNumSamples)
{
  rdu_get_buf(tr,0);
  rdu_check_buf(tr,1);
  int degree = (int) IN0(1);
  float index = IN0(2);
  float *out = OUT(0);
  float r[4];
  int access = (int)IN0(3);
  if(access < 1 || access >= degree) access = 1;
  for(int i = 0; i < inNumSamples; i++) {
    trace_lookup(unit->m_buf_tr->data,
                 unit->m_buf_tr->frames,
                 degree,
                 index,
                 r);
    out[i] = r[access];
  }
}

PluginLoad(TraceRead)
{
  ft = inTable;
  DefineSimpleUnit(TraceRead);
}
