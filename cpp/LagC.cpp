#include <stdio.h>

#include <SC_PlugIn.h>

static InterfaceTable *ft;

struct LagC : public Unit {
  float m_in_1;
  double m_curve,m_start,m_end,m_index,m_incr;
};

double curve(double c,double x0,double x1,double t)
{
  if (abs(c) < 0.0001) {
      return x0 + (x1 - x0) * t;
  } else {
      double d = 1 - exp(c);
      double n = 1 - exp(t * c);
      return x0 + (x1 - x0) * (n / d);
  }
}

/* #define d_printf printf */
#define d_printf(...)

/* AUDIO RATE NOT WORKING... */
void LagC_next(LagC *unit, int inNumSamples)
{
  float *out = OUT(0);
  float *in = IN(0);
  float in_1 = unit->m_in_1;

  d_printf("inNumSamples=%d\n", inNumSamples);
  for(int i = 0; i < inNumSamples; i++) {
    if (unit->m_index >= 1.0) {
      out[i] = unit->m_end;
    } else {
      out[i] = curve(unit->m_curve, unit->m_start, unit->m_end, unit->m_index);
      unit->m_index += unit->m_incr;
    }
    d_printf("in_1=%f, in[i]=%f, i=%d\n", in_1, in[i], i);
    if ( in[i] != in_1 ) {
      d_printf("lag-up=%f, curve-up=%f, lag-down=%f, curve-down=%f\n", IN0(1), IN0(2), IN0(3), IN0(4));
      unit->m_start = out[i];
      unit->m_end = in[i];
      if ( unit->m_start < unit->m_end ) {
        /* UP */
        unit->m_incr = 1.0 / (IN0(1) * unit->mRate->mSampleRate);
        unit->m_curve = IN0(2);
      } else {
        /* DOWN */
        unit->m_incr = 1.0 / (IN0(3) * unit->mRate->mSampleRate);
        unit->m_curve = IN0(4);
      }
      unit->m_index = unit->m_incr;
      d_printf("in[i-1]=%f, in[i]=%f, curve=%f, start=%f, end=%f, index=%f, incr=%f\n",
               in_1, in[i], unit->m_curve, unit->m_start, unit->m_end, unit->m_index, unit->m_incr);
    }
    in_1 = in[i];
  }
  unit->m_in_1 = in_1;
}

void LagC_Ctor(LagC* unit)
{
  SETCALC(LagC_next);
  unit->m_in_1 = IN0(0);
  unit->m_curve = 0.0;
  unit->m_start = IN0(0);
  unit->m_index = 1.0;
  unit->m_incr = 0.0;
  LagC_next(unit, 1);
}

PluginLoad(LagC) {
  ft = inTable;
  DefineSimpleUnit(LagC);
}
