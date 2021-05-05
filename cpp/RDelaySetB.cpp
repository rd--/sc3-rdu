#include <stdio.h>
#include <SC_PlugIn.h>

#include "c-commonr/cq.c"
#include "c-commonr/signal-interpolate.c"

#include "RDelaySet.h"
#include "rdu.h"

static InterfaceTable *ft;

struct RDelaySetB : public Unit
{
  rdu_declare_buf(dl);
  rdelayset_struct_common;
};

rdu_prototypes(RDelaySetB)

void RDelaySetB_Ctor(RDelaySetB *unit)
{
  rdu_init_buf(dl);
  rdelayset_ctor_common(2);
  SETCALC(RDelaySetB_next);
  RDelaySetB_next(unit,1);
}

void RDelaySetB_next(RDelaySetB *unit,int inNumSamples)
{
  rdu_get_buf(dl,0);
  rdu_check_buf(dl,1);
  if(unit->m_buf_dl->frames - 1 < unit->m_signal_n) {
    return;
  } else {
    unit->m_signal = unit->m_buf_dl->data;
  }
  rdelayset_next_common(1);
}

rdu_load(RDelaySetB)
