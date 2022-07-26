#include <stdio.h>

#include <SC_PlugIn.h>

#include "r-common/c/trace.c"

#include "rdu.h"

static InterfaceTable *ft;

struct TracePlay : public Unit
{
  rdu_declare_buf(tr);
  double m_phase;
};

rdu_prototypes(TracePlay)

void TracePlay_Ctor(TracePlay *unit)
{
  rdu_init_buf(tr);
  unit->m_phase = 0.0;
  SETCALC(TracePlay_next);
}

void TracePlay_next(TracePlay *unit, int inNumSamples)
{
  rdu_get_buf(tr,0);
  rdu_check_buf(tr,1);
  int degree = (int) IN0(1);
  float rate = IN0(2);
  double incr = (1.0 / SAMPLERATE) * rate;
  float *out = OUT(0);
  float r[4];
  int access = (int)IN0(3);
  if(access < 1 || access >= degree) access = 1;
  for(int i = 0; i < inNumSamples; i++) {
    trace_lookup(unit->m_buf_tr->data,
                 unit->m_buf_tr->frames,
                 degree,
                 unit->m_phase,
                 r);
    out[i] = r[access];
    unit->m_phase += incr;
    if(unit->m_phase >= 1.0) {
      unit->m_phase -= 1.0;
    }
  }
}

PluginLoad(TracePlay)
{
  ft = inTable;
  DefineSimpleUnit(TracePlay);
}
