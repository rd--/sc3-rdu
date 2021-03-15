#include <math.h>
#include <stdbool.h>
#include <stdio.h>

#include <SC_PlugIn.h>

#include "c-common/gen-trapezoid.c"
#include "c-common/quantize.c"
#include "c-common/rand.c"
#include "c-common/segment-transfer.c"
#include "c-common/signal-interpolate.c"
#include "c-common/taus88.c"

#include "rdu.h"

static InterfaceTable *ft;

typedef struct
{
  float duration;		/* seconds */
  float read_location;		/* (0,1) */
  float read_increment;         /* (-inf,+inf) */
  float stereo_location;	/* (0,1) */
  bool active;			/* active flag */
  int sdur;			/* duration in samples */
  int scnt;			/* sample count for active grain */
  float e[8];			/* envelope array */
}
grain_t;

/* Static limit on the number of concurrent grains. */
#define N_GRAINS 256

struct RShufflerB : public Unit
{
  rdu_declare_buf(dl);
  float m_buf_dl_location;   /* current read location at the buffer */
  long m_count;              /* number of samples processed */
  long m_last;               /* last grain onset */
  float m_iot;               /* inter-onset time */
  int m_free_slot;           /* a known free grain or -1 */
  grain_t m_grain[N_GRAINS]; /* grain array */
};

rdu_prototypes(RShufflerB)

/* Symbolic names for control port indicies. */
#define BUFFER_NUMBER          0
#define READ_LOCATION_L        1
#define READ_LOCATION_R        2
#define READ_INCREMENT_L       3
#define READ_INCREMENT_R       4
#define DURATION_L             5
#define DURATION_R             6
#define ENV_AMPLITUDE_L        7
#define ENV_AMPLITUDE_R        8
#define ENV_SHAPE_L            9
#define ENV_SHAPE_R            10
#define ENV_SKEW_L             11
#define ENV_SKEW_R             12
#define STEREO_LOCATION_L      13
#define STEREO_LOCATION_R      14
#define IOT_L                  15
#define IOT_R                  16
#define FTABLE_READ_INCREMENT  17
#define READ_INCREMENT_QUANTUM 18
#define IOT_QUANTUM            19
#define NUMBER_OF_CONTROLS     20

/* Resolve random range (LEFT,RIGHT) to value, Q = quantize */
#define RLR_AT(l)(rand_f32(controls[(l)],controls[(l)+1]))
#define RLR_AT_Q(l,q)(controls[(q)]>0.0?quantize(controls[(q)],RLR_AT((l))):RLR_AT((l)))

/* Resolve random range (CENTER,DEVIATION) to value, Q = quantize */
#define RCD_AT(l)(rand_f32(controls[(l)]-controls[(l)+1],controls[(l)]+controls[(l)+1]))
#define RCD_AT_Q(l,q)(controls[(q)]>0.0?quantize(controls[(q)],RCD_AT((l))):RCD_AT((l)))

/* Make a grain from control inputs. */
inline static void
setup_grain(RShufflerB *unit,grain_t *g,float *controls)
{
  g->read_location = RLR_AT(READ_LOCATION_L);
  g->read_location *= unit->m_buf_dl->frames - 1;
  g->read_location += unit->m_buf_dl_location;
  g->read_increment = RLR_AT_Q(READ_INCREMENT_L,READ_INCREMENT_QUANTUM);
  g->duration = RLR_AT(DURATION_L);
  float env_amplitude = RLR_AT(ENV_AMPLITUDE_L);
  float env_shape = RLR_AT(ENV_SHAPE_L);
  float env_skew = RLR_AT(ENV_SKEW_L);
  g->stereo_location = RLR_AT(STEREO_LOCATION_L);
  gen_trapezoid(g->e,8,env_amplitude,env_shape,env_skew);
  g->sdur =(int)(g->duration * SAMPLERATE);
  g->scnt = 0;
  g->active = true;
}

/* If `z' is less than zero, or greater than or equal to `n',wrap by `n' places. */
inline static void
wrap_index(int n,float *z)
{
  if(*z >= n) {
    *z -= n;
  } else if(*z < 0) {
    *z += n - 1;
  }
}

/* Locate the next free grain slot after index `n' and store the slot
   number.  If there is no such slot return 0,else 1. */
inline static int
locate_free_slot(RShufflerB *unit,int i)
{
  if(unit->m_free_slot != -1) {
    return 1;
  }
  for(; i < N_GRAINS; i++) {
    if(!unit->m_grain[i].active) {
      unit->m_free_slot = i;
      return 1;
    }
  }
  unit->m_free_slot = -1;
  return 0;
}

/* Called to enqueue a grain if it is due by the iot.  Find an
   inactive grain. If there is not one known we must search from the
   start.  If at the end there is still not one known the grain cannot
   be queued.  If the grain can be queued an abstract grain is made
   from the control inputs and the required fields are mapped into the
   current context. */
inline static void
enqueue_grain(RShufflerB *unit,float *controls)
{
  if((unit->m_count - unit->m_last) <= unit->m_iot) {
    return;
  }
  if(!locate_free_slot(unit,0)) {
    return;
  }
  unit->m_last = unit->m_count;
  unit->m_iot = RLR_AT_Q(IOT_L,IOT_QUANTUM) * SAMPLERATE;
  setup_grain(unit,&(unit->m_grain[unit->m_free_slot]),controls);
  /* This grain slot is no longer free.  In the belief that slot
     availability when busy is more or less linear we try here to find
     the next slot following this that is available.  However we do
     not cycle around,since the search above will start at zero. */
  unit->m_free_slot = -1;
  locate_free_slot(unit,unit->m_free_slot + 1);
}

void RShufflerB_Ctor(RShufflerB *unit)
{
  rdu_init_buf(dl);
  unit->m_buf_dl_location = 0.0;
  unit->m_count = 0;
  unit->m_last = 0;
  unit->m_iot = 0;
  unit->m_free_slot = 0;
  for(int i = 0; i < N_GRAINS; i++) {
    unit->m_grain[i].active = false;
  }
  SETCALC(RShufflerB_next);
  RShufflerB_next(unit,1);
}

void RShufflerB_next(RShufflerB *unit,int inNumSamples)
{
  rdu_get_buf(dl,BUFFER_NUMBER);
  rdu_check_buf(dl,1);
  rdu_get_controls(NUMBER_OF_CONTROLS);
  float *out_l = OUT(0);
  float *out_r = OUT(1);
  for(int i = 0; i < inNumSamples; i++) {
    out_l[i] = out_r[i] = 0.0;
    enqueue_grain(unit,controls);
    for(int j = 0; j < N_GRAINS; j++) {
      grain_t *g = &(unit->m_grain[j]);
      if(!g->active) {
	continue;
      }
      if(g->scnt >= g->sdur) {
	g->active = false;
	continue;
      }
      wrap_index(unit->m_buf_dl->frames,&(g->read_location));
      float s =  signal_interpolate(unit->m_buf_dl->data,unit->m_buf_dl->frames,g->read_location);
      s *= segment_transfer_lookup_linear(g->e,8,(float)(g->scnt) /(float)(g->sdur));
      out_l[i] += s *(1.0 - g->stereo_location);
      out_r[i] += s * g->stereo_location;
      g->scnt += 1;
      g->read_location += g->read_increment;
    }
    /* Increment and modulo ftable read location and increment the shuffler sample count. */
    unit->m_buf_dl_location += controls[FTABLE_READ_INCREMENT];
    wrap_index(unit->m_buf_dl->frames,&(unit->m_buf_dl_location));
    unit->m_count++;
  }
}

rdu_load(RShufflerB)
