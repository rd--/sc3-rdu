#include <stdio.h>
#include <SC_PlugIn.h>
#include "rdu.h"

static InterfaceTable *ft;

struct RBezier : public Unit {
    float m_phase;
    int m_points;
};

/*
  fr ph
        x0 y0 cx0 cy0 cx1 cy1 x1 y1
                              x0 y0 cx0 cy0 cx1 cy1 x1 y1
                                                    x0 y0 cx0 cy0 cx1 cy1 x1 y1
*/

#define R float

void bezier4(R x1,R y1,R x2,R y2,R x3,R y3,R x4,R y4,R mu,R *rx,R *ry)
{
    R a = 1 - mu;
    R b = a*a*a;
    R c = mu*mu*mu;
    *rx = b*x1 + 3*mu*a*a*x2 + 3*mu*mu*a*x3 + c*x4;
    *ry = b*y1 + 3*mu*a*a*y2 + 3*mu*mu*a*y3 + c*y4;
}

#define x0(i) ZIN0(i+0)
#define y0(i) ZIN0(i+1)
#define x1(i) ZIN0(i+2)
#define y1(i) ZIN0(i+3)
#define x2(i) ZIN0(i+4)
#define y2(i) ZIN0(i+5)
#define x3(i) ZIN0(i+6)
#define y3(i) ZIN0(i+7)

R unwrap_mu(R x0,R x3,R mu) {
    R d = x3 - x0;
    return (mu - x0) / d;
}

R next_mu(R x0,R x3) {
    return x0 + ((x3 - x0) / 2);
}

R bezier4_y_mt(int halt,R dx,R x0,R y0,R x1,R y1,R x2,R y2,R x3,R y3,R x) {
    R mu = x0 + ((x3 - x0) / 2);
    R l = x0;
    R r = x3;
    for(int i = 0;i < halt;i++) {
        R mu_ = unwrap_mu(x0,x3,mu);
        R rx, ry;
        bezier4(x0,y0,x1,y1,x2,y2,x3,y3,mu_,&rx,&ry);
        if(fabsf(x - rx) <= dx) { return ry; }
        if(rx < x) { l = mu; } else { r = mu; }
        mu = next_mu(l,r);
    }
    printf("RBezier: did not resolve in required steps\n");
    return 0.0;
}

#define HALT_AFTER 100

void RBezier_next(RBezier *unit,int inNumSamples)
{
    R *out = OUT(0);
    R ph = unit->m_phase;
    R ph_incr = ZIN0(0) / unit->mWorld->mSampleRate;
    for(int i = 0;i < inNumSamples; i++) {
        bool done = false;
        for(int j = 0;j < unit->m_points;j++) {
            int pt = 2 + (j * 6);
            if(ph >= x0(pt) && ph <= x3(pt)) {
                out[i] = bezier4_y_mt(HALT_AFTER,0.0001
                                      ,x0(pt),y0(pt)
                                      ,x1(pt),y1(pt)
                                      ,x2(pt),y2(pt)
                                      ,x3(pt),y3(pt)
                                      ,ph);
                done = true;
#if 0
                printf("%i/%i (%.3f,.3%f) (%.3f,%.3f) (%.3f,%.3f) (%.3f,%.3f) %.3f/%.3f\n"
                       ,i,j
                       ,x0(pt),y0(pt)
                       ,x1(pt),y1(pt)
                       ,x2(pt),y2(pt)
                       ,x3(pt),y3(pt)
                       ,ph,out[i]);
#endif
            }
        }
        if (!done) {
            printf("RBezier: ph = %f\n",ph);
            out[i] = 0.0;
        }
        ph += ph_incr;
        if (ph > 1.0) { ph -= 1.0; }
    }
    unit->m_phase = ph;
}

void RBezier_Ctor(RBezier* unit)
{
  unit->m_phase = ZIN0(1);
  unit->m_points = 1 + ((unit->mNumInputs - 4) / 6);
  SETCALC(RBezier_next);
  ZOUT0(0) = 0.0;
}

PluginLoad(RandN)
{
  ft = inTable;
  DefineSimpleUnit(RBezier);
}
