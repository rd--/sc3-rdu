#include <stdio.h>
#include <SC_PlugIn.h>
#include "c-common/rand.c"
#include "c-common/signal-interpolate.c"
#include "c-common/taus88.c"
#include "rdu.h"

static InterfaceTable *ft;

typedef struct
{
  /* Static increment for loop traversal,modified by group value. */
  float increment;
  /* Instantaneous phase value. */
  float phase;
  /* The resolved right sample index.  When the phase reaches this
     value the loop is reset,unless the group right value is shifted
     to lie to the left of this value. */
  int right;
}
RFreezer_Loop_t;

#define LOOP_LIMIT 36

struct RFreezer : public Unit
{
  rdu_declare_monitored_buf(dl);
  /* The loop data array. */
  RFreezer_Loop_t m_loop_data[LOOP_LIMIT];
  /* The number of active loops. */
  int m_loop_n;
  /* The resolved left and right window sample indices,and the size
     of the window.  These are calculated once per period.  */
  int m_left;
  int m_right;
  int m_size;
  /* The phase synchronize and randomize trigger states. */
  float m_phase_synchronize_trigger_state;
  float m_phase_randomize_trigger_state;
};

rdu_prototypes(RFreezer);

#define BUFFER_NUMBER             0
#define GROUP_LEFT                IN0(1)
#define GROUP_RIGHT               IN0(2)
#define GROUP_GAIN                IN0(3)
#define GROUP_INCREMENT           IN0(4)
#define INCREMENT_OFFSET          IN0(5)
#define INCREMENT_RANDOM          IN0(6)
#define RIGHT_RANDOM              IN0(7)
#define PHASE_SYNCHRONIZE_TRIGGER IN0(8)
#define PHASE_RANDOMIZE_TRIGGER   IN0(9)
#define LOOP_COUNT                IN0(10)

/* Return an index near `index' that corresponds to an ascending zero
   crossing at `sound'. If no zero crossing is located returns
   `index'. */
inline static int
RFreezer_find_near_zero_crossing(float *sound,int sound_n,int index)
{
  float s;
  int i;
  /* Look forwards. */
  s = sound[index];
  for(i = index + 1; i < sound_n; i++) {
    if(s <= 0.0 && sound[i] >= 0.0) {
      return i;
    }
    s = sound[i];
  }
  /* Look backwards. */
  s = sound[index];
  for(i = index - 1; i >= 0; i--) {
    if(s >= 0.0 && sound[i] <= 0.0) {
      return i;
    }
    s = sound[i];
  }
  return index;
}

/* Setup loop for single traversal. */
inline static void
RFreezer_loop_setup(RFreezer *unit,int index)
{
  RFreezer_Loop_t *loop = unit->m_loop_data + index;
  float l_right;
  /* Set increment value,this is constant for the whole loop
     traversal. The increment incorporates the global offset and
     randomizer values. */
  loop->increment  = 1.0 +(INCREMENT_OFFSET * index);
  loop->increment *= 1.0 +(INCREMENT_RANDOM * randf32(0,1));
  /* Set calculated left and right locations.  Left is not stored,it
     is the inital phase location. The right value incorporates the
     global randomizer value. */
  loop->phase = unit->m_left;
  l_right  = 1.0;
  l_right *= 1.0 +(RIGHT_RANDOM * randf32 (0,1));
  l_right  =(l_right > 1.0)? 1.0 : l_right;
  loop->right = (int)((float)unit->m_left +(l_right * (float)unit->m_size));
  /* Shift phase and right to lie on zero crossings. */
  loop->phase = (float)RFreezer_find_near_zero_crossing(unit->m_buf_dl->data,
                                                        unit->m_buf_dl->frames,
                                                        (int)loop->phase);
  loop->right = RFreezer_find_near_zero_crossing(unit->m_buf_dl->data,
						   unit->m_buf_dl->frames,
						   loop->right);
}

/* Setup group data. This resolves 0-1 user inputs to buffer relative
   values.  */
inline static void
RFreezer_group_setup(RFreezer *unit)
{
  unit->m_left = (int)(unit->m_buf_dl->frames * GROUP_LEFT);
  unit->m_right = (int)(unit->m_buf_dl->frames * GROUP_RIGHT);
  unit->m_size = unit->m_right - unit->m_left;
  /* Shift right to lie on a zero crossing,this is relevant since it
     is a reset point for individual loops. */
  unit->m_right = RFreezer_find_near_zero_crossing(unit->m_buf_dl->data,
						     unit->m_buf_dl->frames,
						     unit->m_right);
}

inline static void
RFreezer_reset(RFreezer *unit)
{
  RFreezer_group_setup(unit);
  for(int i = 0; i < LOOP_LIMIT; i++) {
    RFreezer_loop_setup(unit,i);
  }
}

/* Shift the phase of all active loops to a random value between the
   current phase location and the loop end point. */
inline static void
RFreezer_phase_randomize(RFreezer *unit)
{
  int i;
  for(i = 0; i < unit->m_loop_n; i++) {
    RFreezer_Loop_t *loop = unit->m_loop_data + i;
    loop->phase = randf32(loop->phase,loop->right);
  }
}

/* Reset all active loops. */
inline static void
RFreezer_phase_synchronize(RFreezer *unit)
{
  int i;
  RFreezer_group_setup(unit);
  for(i = 0; i < unit->m_loop_n; i++) {
    RFreezer_loop_setup(unit,i);
  }
}

void RFreezer_Ctor(RFreezer *unit)
{
  rdu_init_monitored_buf(dl);
  unit->m_phase_synchronize_trigger_state = 0.0;
  SETCALC(RFreezer_next);
  RFreezer_next(unit,1);
}

void RFreezer_next(RFreezer *unit,int inNumSamples)
{
  rdu_get_buf(dl,BUFFER_NUMBER);
  rdu_check_buf(dl,1);
  rdu_on_buffer_change(dl,RFreezer_reset(unit););
  float *out = OUT(0);
  /* Set number of active loops, silently clip to limit. */
  unit->m_loop_n = (int) fminf(LOOP_COUNT,LOOP_LIMIT);
  /* Check phase synchronize trigger. */
  float trigger = PHASE_SYNCHRONIZE_TRIGGER;
  if(trigger > 0.0 && unit->m_phase_synchronize_trigger_state <= 0.0) {
    RFreezer_phase_synchronize(unit);
  }
  unit->m_phase_synchronize_trigger_state = trigger;
  /* Check phase randomize trigger. */
  trigger = PHASE_RANDOMIZE_TRIGGER;
  if(trigger > 0.0 && unit->m_phase_randomize_trigger_state <= 0.0) {
    RFreezer_phase_randomize(unit);
  }
  unit->m_phase_randomize_trigger_state = trigger;
  /* Reset the group data. */
  RFreezer_group_setup(unit);
  for(int i = 0; i < inNumSamples; i++) {
    /* Zero output. */
    out[i] = 0.0;
    for(int j = 0; j < unit->m_loop_n; j++) {
      RFreezer_Loop_t *loop = unit->m_loop_data + j;
      /* Sum loop value into output and increment phase. */
      out[i] += signal_interpolate(unit->m_buf_dl->data,
				     unit->m_buf_dl->frames,
				     loop->phase);
      loop->phase += loop->increment * GROUP_INCREMENT;
      /* Reset loop if required.  Loops reset at their own 'right'
	 value,or at the group 'right' value.  */
      if(loop->phase >= loop->right || loop->phase >= unit->m_right) {
	RFreezer_loop_setup(unit,j);
      }
    }
    /* Apply group gain. */
    out[i] *= GROUP_GAIN;
  }
}

rdu_load(RFreezer);
