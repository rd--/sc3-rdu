#include <stdio.h>
#include <SC_PlugIn.h>

#include "r-common/c/cq.c"
#include "r-common/c/signal-interpolate.c"

#include "DelaySet.h"
#include "rdu.h"

static InterfaceTable *ft;

struct DelaySetBuf : public Unit
{
  rdu_declare_buf(dl);
  delayset_struct_common;
};

rdu_prototypes(DelaySetBuf)

void DelaySetBuf_Ctor(DelaySetBuf *unit)
{
  rdu_init_buf(dl);
  delayset_ctor_common(2);
  SETCALC(DelaySetBuf_next);
  DelaySetBuf_next(unit,1);
}

void DelaySetBuf_next(DelaySetBuf *unit,int inNumSamples)
{
  rdu_get_buf(dl,0);
  rdu_check_buf(dl,1);
  if(unit->m_buf_dl->frames - 1 < unit->m_signal_n) {
    return;
  } else {
    unit->m_signal = unit->m_buf_dl->data;
  }
  delayset_next_common(1);
}

rdu_load(DelaySetBuf)
