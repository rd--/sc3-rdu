#include <stdio.h>
#include <SC_PlugIn.h>

#include "c-common/cq.c"
#include "c-common/signal-interpolate.c"

#include "RDelaySet.h"
#include "rdu.h"

static InterfaceTable *ft;

typedef struct
{
  float location;
  float feed_forward;
  float feed_backward;
}
tap_t;

struct RDelaySetB : public Unit
{
  rdu_declare_buf;
  rdelayset_struct_common;
};

rdu_prototypes(RDelaySetB);

void RDelaySetB_Ctor(RDelaySetB *unit)
{
  rdu_init_buf;
  rdelayset_ctor_common(2);
  SETCALC(RDelaySetB_next);
}

void RDelaySetB_next(RDelaySetB *unit,int inNumSamples)
{
  rdu_get_buf(0);
  rdu_check_buf(1);
  if(unit->m_buf->frames - 1 < unit->m_signal_n) {
    return;
  } else {
    unit->m_signal = unit->m_buf->data;
  }
  rdelayset_next_common(1);
}

rdu_load(RDelaySetB);
