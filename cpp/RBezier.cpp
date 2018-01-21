#include <assert.h>
#include <stdio.h>
#include <SC_PlugIn.h>

#include "c-common/bezier.c"

static InterfaceTable *ft;

struct RBezier:public Unit {
  float m_phase;
  int m_points;
};

extern "C" {
  void load(InterfaceTable * inTable);
  void RBezier_Ctor(RBezier * unit);
  void RBezier_next(RBezier * unit, int inNumSamples);
}

#define CFG_HALT_AFTER 100

/*
  fr ph
        x0 y0 cx0 cy0 cx1 cy1 x1 y1
                              x0 y0 cx0 cy0 cx1 cy1 x1 y1
                                                    x0 y0 cx0 cy0 cx1 cy1 x1 y1
*/

#define x0(i) ZIN0(i+0)
#define y0(i) ZIN0(i+1)
#define x1(i) ZIN0(i+2)
#define y1(i) ZIN0(i+3)
#define x2(i) ZIN0(i+4)
#define y2(i) ZIN0(i+5)
#define x3(i) ZIN0(i+6)
#define y3(i) ZIN0(i+7)

void RBezier_next(RBezier * unit, int inNumSamples) {
  float *out = OUT(0);
  float ph = unit->m_phase;
  float ph_incr = ZIN0(0) / unit->mRate->mSampleRate;
  assert(ph_incr > 0.0 && ph_incr <= 1.0);
  for (int i = 0; i < inNumSamples; i++) {
    bool coherent = false;
    out[i] = 0.0;
    assert(ph >= 0.0 && ph <= 1.0);
    for (int j = 0; j < unit->m_points; j++) {
      int pt = 2 + (j * 6);
      if (ph >= x0(pt) && ph <= x3(pt)) {
        out[i] = bezier4_y_mt(CFG_HALT_AFTER, 0.0001,
                              x0(pt), y0(pt),
                              x1(pt), y1(pt),
                              x2(pt), y2(pt),
                              x3(pt), y3(pt),
                              ph);
        coherent = true;
#if 0
        printf("%i/%i (%.3f,.3%f) (%.3f,%.3f) (%.3f,%.3f) (%.3f,%.3f) %.3f/%.3f\n", i, j,
               x0(pt), y0(pt), x1(pt), y1(pt), x2(pt), y2(pt), x3(pt), y3(pt), ph, out[i]);
#endif
      }
    }
    if (!coherent) {
      printf("RBezier: incoherent, ph = %f\n", ph);
    }
    ph += ph_incr;
    if (ph > 1.0) {
      ph -= 1.0;
    }
  }
  unit->m_phase = ph;
}

void RBezier_Ctor(RBezier * unit) {
  unit->m_phase = ZIN0(1);
  unit->m_points = 1 + ((unit->mNumInputs - 4) / 6);
  printf("RBezier: initial-phase = %0.3f, # points = %d\n", unit->m_phase, unit->m_points);
  SETCALC(RBezier_next);
  assert(ZIN0(1) >= 0.0 && ZIN0(1) <= 1.0);
  assert((int) unit->mNumInputs == ((unit->m_points - 1) * 6) + 4);
  RBezier_next(unit, 1);
}

PluginLoad(name) {
  ft = inTable;
  DefineSimpleUnit(RBezier);
}
