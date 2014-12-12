#include <assert.h>
#include <stdio.h>
#include <SC_PlugIn.h>

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

#define R float

void bezier4(R x0, R y0, R x1, R y1, R x2, R y2, R x3, R y3, R mu, R * rx, R * ry) {
  R a = 1 - mu;
  R b = a * a * a;
  R c = mu * mu * mu;
  *rx = b * x0 + 3 * mu * a * a * x1 + 3 * mu * mu * a * x2 + c * x3;
  *ry = b * y0 + 3 * mu * a * a * y1 + 3 * mu * mu * a * y2 + c * y3;
  assert(mu >= 0.0 && mu <= 1.0);
  assert(x0 < x3);
  assert(*rx >= x0 && *rx <= x3);
}

R unwrap_mu(R x0, R x3, R mu) {
  assert(mu >= x0 && mu <= x3);
  return (mu - x0) / (x3 - x0);
}

R next_mu(R x0, R x3) {
  assert(x0 < x3);
  return x0 + ((x3 - x0) / 2);
}

R bezier4_y_mt(int halt, R dx, R x0, R y0, R x1, R y1, R x2, R y2, R x3, R y3, R x) {
  R mu = x0 + ((x3 - x0) / 2);
  R l = x0;
  R r = x3;
  for (int i = 0; i < halt; i++) {
    R mu_ = unwrap_mu(x0, x3, mu);
    R rx, ry;
    bezier4(x0, y0, x1, y1, x2, y2, x3, y3, mu_, &rx, &ry);
    if (fabsf(x - rx) <= dx) {
      return ry;
    }
    if (rx < x) {
      l = mu;
    } else {
      r = mu;
    }
    mu = next_mu(l, r);
  }
  printf("RBezier: did not resolve in required steps: %d\n", halt);
  return 0.0;
}

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
  float ph_incr = ZIN0(0) / unit->mWorld->mSampleRate;
  assert(ph_incr > 0.0 && ph_incr <= 1.0);
  for (int i = 0; i < inNumSamples; i++) {
    bool coherent = false;
    out[i] = 0.0;
    assert(ph >= 0.0 && ph <= 1.0);
    for (int j = 0; j < unit->m_points; j++) {
      int pt = 2 + (j * 6);
      if (ph >= x0(pt) && ph <= x3(pt)) {
        out[i] = bezier4_y_mt(CFG_HALT_AFTER, 0.0001, x0(pt), y0(pt),
                              x1(pt), y1(pt), x2(pt), y2(pt), x3(pt), y3(pt), ph);
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
}

PluginLoad(name) {
  ft = inTable;
  DefineSimpleUnit(RBezier);
}
