#include <stdio.h>

#include <SC_PlugIn.h>

#include "r-common/c/signal-interpolate.c"

#include "rdu.h"

static InterfaceTable *ft;

typedef struct
{
	/* Static increment for loop traversal, modified by group value. */
	float increment;
	/* Instantaneous phase value. */
	float phase;
	/* The resolved right sample index.  When the phase reaches this
	   value the loop is reset, unless the group right value is shifted
	   to lie to the left of this value. */
	int right;
} Freezer_Loop_t;

#define LOOP_LIMIT 64 /* Static maximum number of concurrent loops */

struct Freezer : public Unit {
	rdu_declare_monitored_buf(dl);
	/* The loop data array. */
	Freezer_Loop_t m_loop_data[LOOP_LIMIT];
	/* The number of active loops. */
	int m_loop_n;
	/* The resolved left and right window sample indices, and the size
	   of the window.  These are calculated once per period.  */
	int m_left;
	int m_right;
	int m_size;
	/* The phase synchronize and randomize trigger states. */
	float m_phase_synchronize_trigger_state;
	float m_phase_randomize_trigger_state;
};

#define BUFFER_NUMBER 0
#define GROUP_LEFT IN0(1)
#define GROUP_RIGHT IN0(2)
#define GROUP_GAIN IN0(3)
#define GROUP_INCREMENT IN0(4)
#define INCREMENT_OFFSET IN0(5) /* multiplied by loop index (number) and added to increment */
#define INCREMENT_RANDOM IN0(6)
#define RIGHT_RANDOM IN0(7)
#define PHASE_SYNCHRONIZE_TRIGGER IN0(8)
#define PHASE_RANDOMIZE_TRIGGER IN0(9)
#define LOOP_COUNT IN0(10)

/* Return an index near `index' that corresponds to an ascending zero
   crossing at `sound'. If no zero crossing is located returns
   `index'. */
inline static int Freezer_find_near_zero_crossing(float *sound, int sound_n, int index)
{
	float s;
	int i;
	/* Look forwards. */
	s = sound[index];
	for (i = index + 1; i < sound_n; i++) {
		if (s <= 0.0 && sound[i] >= 0.0) {
			return i;
		}
		s = sound[i];
	}
	/* Look backwards. */
	s = sound[index];
	for (i = index - 1; i >= 0; i--) {
		if (s >= 0.0 && sound[i] <= 0.0) {
			return i;
		}
		s = sound[i];
	}
	return index;
}

/* Setup loop for single traversal. */
inline static void
Freezer_loop_setup(Freezer *unit, int index)
{
	Freezer_Loop_t *loop = unit->m_loop_data + index;
	RGen &rgen = *unit->mParent->mRGen;
	float l_right;
	/* Set increment value, this is constant for the whole loop
	   traversal. The increment incorporates the global offset and
	   randomizer values. */
	loop->increment = 1.0 + (INCREMENT_OFFSET * index);
	loop->increment *= 1.0 + (INCREMENT_RANDOM * rgen.frand());
	/* Set calculated left and right locations.  Left is not stored,it
	   is the inital phase location. The right value incorporates the
	   global randomizer value. */
	loop->phase = unit->m_left;
	l_right = 1.0;
	l_right *= 1.0 + (RIGHT_RANDOM * rgen.frand());
	l_right = (l_right > 1.0) ? 1.0 : l_right;
	loop->right = (int)((float)unit->m_left + (l_right * (float)unit->m_size));
	/* Shift phase and right to lie on zero crossings. */
	loop->phase = (float)Freezer_find_near_zero_crossing(unit->m_buf_dl->data,
		unit->m_buf_dl->frames,
		(int)loop->phase);
	loop->right = Freezer_find_near_zero_crossing(unit->m_buf_dl->data,
		unit->m_buf_dl->frames,
		loop->right);
}

/* Setup group data. This resolves 0-1 user inputs to buffer relative
   values.  */
inline static void
Freezer_group_setup(Freezer *unit)
{
	unit->m_left = (int)(unit->m_buf_dl->frames * GROUP_LEFT);
	unit->m_right = (int)(unit->m_buf_dl->frames * GROUP_RIGHT);
	unit->m_size = unit->m_right - unit->m_left;
	/* Shift right to lie on a zero crossing,this is relevant since it
	   is a reset point for individual loops. */
	unit->m_right = Freezer_find_near_zero_crossing(unit->m_buf_dl->data,
		unit->m_buf_dl->frames,
		unit->m_right);
}

inline static void
Freezer_reset(Freezer *unit)
{
	Freezer_group_setup(unit);
	for (int i = 0; i < LOOP_LIMIT; i++) {
		Freezer_loop_setup(unit, i);
	}
}

/* Shift the phase of all active loops to a random value between the
   current phase location and the loop end point. */
inline static void
Freezer_phase_randomize(Freezer *unit)
{
	RGen &rgen = *unit->mParent->mRGen;
	for (int i = 0; i < unit->m_loop_n; i++) {
		Freezer_Loop_t *loop = unit->m_loop_data + i;
		loop->phase = rgen.frand() * ((float)loop->right - loop->phase) + loop->phase;
	}
}

/* Reset all active loops. */
inline static void
Freezer_phase_synchronize(Freezer *unit)
{
	int i;
	Freezer_group_setup(unit);
	for (i = 0; i < unit->m_loop_n; i++) {
		Freezer_loop_setup(unit, i);
	}
}

void Freezer_next(Freezer *unit, int inNumSamples)
{
	rdu_get_buf(dl, BUFFER_NUMBER);
	rdu_check_buf(dl, 1);
	rdu_on_buffer_change(dl, Freezer_reset(unit););
	float *out = OUT(0);
	/* Set number of active loops, silently clip to limit. */
	unit->m_loop_n = (int)fminf(LOOP_COUNT, LOOP_LIMIT);
	/* Check phase synchronize trigger. */
	float trigger = PHASE_SYNCHRONIZE_TRIGGER;
	if (trigger > 0.0 && unit->m_phase_synchronize_trigger_state <= 0.0) {
		Freezer_phase_synchronize(unit);
	}
	unit->m_phase_synchronize_trigger_state = trigger;
	/* Check phase randomize trigger. */
	trigger = PHASE_RANDOMIZE_TRIGGER;
	if (trigger > 0.0 && unit->m_phase_randomize_trigger_state <= 0.0) {
		Freezer_phase_randomize(unit);
	}
	unit->m_phase_randomize_trigger_state = trigger;
	/* Reset the group data. */
	Freezer_group_setup(unit);
	for (int i = 0; i < inNumSamples; i++) {
		/* Zero output. */
		out[i] = 0.0;
		for (int j = 0; j < unit->m_loop_n; j++) {
			Freezer_Loop_t *loop = unit->m_loop_data + j;
			/* Sum loop value into output and increment phase. */
			out[i] += signal_interpolate_circular(unit->m_buf_dl->data,
				unit->m_buf_dl->frames,
				loop->phase);
			loop->phase += loop->increment * GROUP_INCREMENT;
			/* Reset loop if required.  Loops reset at their own 'right'
		   value,or at the group 'right' value.  */
			if (loop->phase >= loop->right || loop->phase >= unit->m_right) {
				Freezer_loop_setup(unit, j);
			}
		}
		/* Apply group gain. */
		out[i] *= GROUP_GAIN;
	}
}

void Freezer_Ctor(Freezer *unit)
{
	rdu_init_monitored_buf(dl);
	unit->m_phase_synchronize_trigger_state = 0.0;
	SETCALC(Freezer_next);
	Freezer_next(unit, 1);
}

rdu_load(Freezer)
