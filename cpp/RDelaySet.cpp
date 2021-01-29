#include <stdio.h>
#include <SC_PlugIn.h>

#include "c-common/cq.c"
#include "c-common/signal-interpolate.c"

#include "RDelaySet.h"
#include "rdu.h"

static InterfaceTable *ft;

struct RDelaySet : public Unit
{
  rdelayset_struct_common;
};

rdu_prototypes_dtor(RDelaySet)

void RDelaySet_next(RDelaySet *unit,int inNumSamples)
{
  rdelayset_next_common(0);
}

void RDelaySet_Ctor(RDelaySet *unit)
{
  rdelayset_ctor_common(1);
  try {
    unit->m_signal =(float*) RTAlloc(unit->mWorld,
                                     unit->m_signal_n * sizeof(float));
    memset((void *)unit->m_signal,0,unit->m_signal_n * sizeof(float));
  } catch(...) {
    fprintf(stderr,"RDelaySet_Ctor: RTAlloc failed...\n");
    unit->m_tap_n = 0;
  }
  SETCALC(RDelaySet_next);
  RDelaySet_next(unit, 1);
}

void RDelaySet_Dtor(RDelaySet *unit)
{
  RTFree(unit->mWorld,unit->m_signal);
}

rdu_load_dtor(RDelaySet)
