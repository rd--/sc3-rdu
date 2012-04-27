#include <stdio.h>
#include <SC_PlugIn.h>
#include "c-common/signal-interpolate.c"
#include "rdu.h"

static InterfaceTable *ft;

typedef struct
{
  float increment;
  float gain;
  float phase;
  int left;
  int right;
}
RLoopSet_Loop_t;

#define LOOP_LIMIT 24

struct RLoopSet : public Unit
{
  rdu_declare_monitored_buf;
  RLoopSet_Loop_t m_loop_data[LOOP_LIMIT];
  int m_loop_n;
  int m_left;
  int m_right;
  int m_size;
};

rdu_prototypes(RLoopSet);

#define BUFFER_NUMBER             0
#define GROUP_LEFT                ZIN0(1)
#define GROUP_RIGHT               ZIN0(2)
#define GROUP_GAIN                ZIN0(3)
#define GROUP_INCREMENT           ZIN0(4)
#define FIXED_INPUTS              5

#define LOOP_LEFT(N)              ZIN0(FIXED_INPUTS+0+(N*4))
#define LOOP_RIGHT(N)             ZIN0(FIXED_INPUTS+1+(N*4))
#define LOOP_GAIN(N)              ZIN0(FIXED_INPUTS+2+(N*4))
#define LOOP_INCREMENT(N)         ZIN0(FIXED_INPUTS+3+(N*4))

/* Return an index near `index' that corresponds to an ascending zero
   crossing at `sound'. If no zero crossing is located returns
   `index'.  Looks forwards first, then backwards. */
static inline int
RLoopSet_finesse(float *sound, int sound_n, int index)
{
  float s;
  int i;
  s = sound[index];
  for(i = index + 1; i < sound_n; i++) {
    if(s <= 0.0 && sound[i] >= 0.0) {
      return i;
    }
    s = sound[i];
  }
  s = sound[index];
  for(i = index - 1; i >= 0; i--) {
    if(s >= 0.0 && sound[i] <= 0.0) {
      return i;
    }
    s = sound[i];
  }
  return index;
}

/* Setup group data. This resolves 0-1 user inputs to buffer relative
   values.  */
static inline void
RLoopSet_group_setup(RLoopSet *unit)
{
  unit->m_left = RLoopSet_finesse(unit->m_buf->data,
                                   unit->m_buf->frames,
                                  (int)(unit->m_buf->frames * GROUP_LEFT));
  unit->m_right = RLoopSet_finesse(unit->m_buf->data,
                                    unit->m_buf->frames,
                                   (int)(unit->m_buf->frames * GROUP_RIGHT));
  unit->m_size = unit->m_right - unit->m_left;
}

/* Setup loop data structure. */
static inline void
RLoopSet_loop_setup(RLoopSet *unit, int index)
{
  RLoopSet_Loop_t *loop = unit->m_loop_data + index;
  /* Set gain and increment values, these are constant for the whole
     loop traversal. The increment incorporates the global offset and
     randomizer values. */
  loop->gain = LOOP_GAIN(index);
  loop->increment = LOOP_INCREMENT(index);
  /* Set calculated left and right locations. These values incorporate
     the global values. */
  loop->left = unit->m_left;
  loop->left +=(int)(LOOP_LEFT(index) * unit->m_size);
  loop->right = unit->m_left;
  loop->right +=(int)(LOOP_RIGHT(index) * unit->m_size);
  /* Shift left and right to lie on zero crossings. */
  loop->left = RLoopSet_finesse(unit->m_buf->data,
				  unit->m_buf->frames,
				  loop->left);
  loop->right = RLoopSet_finesse(unit->m_buf->data,
				   unit->m_buf->frames,
				   loop->right);
  /* Left is the inital phase location. */
  loop->phase =(float) loop->left;
}

static inline void
RLoopSet_reset(RLoopSet *unit)
{
  RLoopSet_group_setup(unit);
  for(int i = 0; i < unit->m_loop_n; i++) {
    RLoopSet_loop_setup(unit, i);
  }
}

void RLoopSet_Ctor(RLoopSet *unit)
{
  rdu_init_monitored_buf;
  unit->m_loop_n =(unit->mNumInputs - FIXED_INPUTS) / 4;
  SETCALC(RLoopSet_next);
}

/* The sample loop is: sum loop value into output and increment phase,
   reset loop if required, apply group gain. */
void RLoopSet_next(RLoopSet *unit,int inNumSamples)
{
  rdu_get_buf(BUFFER_NUMBER);
  rdu_check_buf(1);
  rdu_on_buffer_change(RLoopSet_reset(unit););
  float *out = OUT(0);
  for(int i = 0; i < inNumSamples; i++) {
    out[i] = 0.0;
    for(int j = 0; j < unit->m_loop_n; j++) {
      RLoopSet_Loop_t *loop = unit->m_loop_data + j;
      out[i] += loop->gain * signal_interpolate(unit->m_buf->data,
						  unit->m_buf->frames,
						  loop->phase);
      loop->phase += loop->increment * GROUP_INCREMENT;
      if(loop->phase >= loop->right) {
	loop->phase = loop->left;
      }
    }
    out[i] *= GROUP_GAIN;
  }
}

rdu_load(RLoopSet);