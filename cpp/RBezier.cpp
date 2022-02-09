#include <assert.h>
#include <stdio.h>

#include <SC_PlugIn.h>

#include "r-common/c/bezier.c"
#include "r-common/c/print.h"

static InterfaceTable *ft;

struct RBezier:public Unit {
  int m_halt_after;
  float m_dx;
  float m_phase;
  int m_points;
};

/*
  k dx fr ph
             x0 y0 cx0 cy0 cx1 cy1 x1 y1
                                   x0 y0 cx0 cy0 cx1 cy1 x1 y1
                                                         x0 y0 cx0 cy0 cx1 cy1 x1 y1
*/

void RBezier_next(RBezier * unit, int inNumSamples) {
  float *out = OUT(0);
  int halt_after = unit->m_halt_after;
  float dx = unit->m_dx;
  float ph = unit->m_phase;
  float ph_incr = IN0(2) / unit->mRate->mSampleRate;
  assert(ph_incr > 0.0 && ph_incr <= 1.0);
  for (int i = 0; i < inNumSamples; i++) {
    bool coherent = false;
    out[i] = 0.0;
    assert(ph >= 0.0 && ph <= 1.0);
    for (int j = 0; j < unit->m_points; j++) {
      int pt = 4 + (j * 6);
      float x0 = IN0(pt+0);
      float x3 = IN0(pt+6);
      /* printf("i=%i, j=%i, pt=%d, ph=%.3f, x0=%.3f, x3=%.3f\n",i, j, pt, ph, x0, x3); */
      if (ph >= x0 && ph <= x3) {
        float y0 = IN0(pt+1);
        float x1 = IN0(pt+2);
        float y1 = IN0(pt+3);
        float x2 = IN0(pt+4);
        float y2 = IN0(pt+5);
        float y3 = IN0(pt+7);
        /* printf("(%.3f,.3%f) (%.3f,%.3f) (%.3f,%.3f) (%.3f,%.3f)\n", x0, y0, x1, y1, x2, y2, x3, y3); */
        out[i] = bezier4_y_mt(halt_after, dx, x0, y0, x1, y1, x2, y2, x3, y3, ph);
        coherent = true;
        /* printf("out[i]=%.3f\n",out[i]); */
        break;
      }
    }
    if (!coherent) {
      dprintf("RBezier: incoherent, ph = %f\n", ph);
    }
    ph += ph_incr;
    if (ph > 1.0) {
      ph -= 1.0;
    }
  }
  unit->m_phase = ph;
}

void RBezier_Ctor(RBezier * unit) {
  unit->m_halt_after = (int)IN0(0);
  unit->m_dx = IN0(1);
  unit->m_phase = IN0(3);
  unit->m_points = 1 + ((unit->mNumInputs - 4) / 6);
  dprintf("RBezier: initial-phase = %0.3f, # points = %d\n", unit->m_phase, unit->m_points);
  SETCALC(RBezier_next);
  assert(IN0(3) >= 0.0 && IN0(3) <= 1.0);
  assert((int) unit->mNumInputs == ((unit->m_points - 1) * 6) + 6);
  RBezier_next(unit, 1);
}

PluginLoad(RBezier) {
  ft = inTable;
  DefineSimpleUnit(RBezier);
}
