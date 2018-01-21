#include <math.h>
#include <stdio.h>
#include <SC_PlugIn.h>

#include "c-common/rand.c"
#include "c-common/taus88.c"
#include "rdu.h"

static InterfaceTable *ft;

#define PI           (3.14159265358979323846)
#define TWO_PI       (2*PI)

typedef struct
{
  int phase;
  int size;
  float freq;
  float angle;
}
grain_t;

inline static float
hamming_window_at(float angle)
{
  return 0.54 - 0.46 * cosf(angle);
}

inline static void
grain_init(grain_t *g,int size)
{
  g->phase = 0;
  g->size = size;
  g->freq = TWO_PI /(float)size;
  g->angle = 0.0;
}

inline static float
grain_step(grain_t *g,float s)
{
  if(g->phase < g->size) {
    s *= hamming_window_at(g->angle);
    g->angle += g->freq;
    g->phase += 1;
    return s;
  } else {
    return 0.0;
  }
}

struct RShufflerL : public Unit
{
  grain_t m_grain;
  long m_count;
  long m_next;
};

rdu_prototypes(RShufflerL);

void RShufflerL_Ctor(RShufflerL *unit)
{
  unit->m_count = 0;
  unit->m_next = 0;
  SETCALC(RShufflerL_next);
}

void RShufflerL_next(RShufflerL *unit,int inNumSamples)
{
  float *in = IN(0);
  float *out = OUT(0);
  float fragment_size = IN0(1);
  float max_delay = IN0(2);
  for(int i = 0; i < inNumSamples; i++) {
    if(unit->m_next == unit->m_count) {
      int size = int(fragment_size * SAMPLERATE);
      grain_init(&(unit->m_grain),size);
      int delay = int(randf32(0,1) * max_delay * SAMPLERATE);
      unit->m_next = unit->m_count + size + delay;
    }
    out[i] = grain_step(&(unit->m_grain),in[i]);
    unit->m_count += 1;
  }
}

rdu_load(RShufflerL);
