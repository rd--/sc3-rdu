#include <stdio.h>
#include <SC_PlugIn.h>

/* cq = circular queue, n = buffer length, ri = read index, wi = write
   index, ai = absolute index, s = buffer */

int cq_index_i(int n, int ri, int wi)
{
  int ai = (wi - 1) - ri;
  if(ai < 0) {
    ai += n;
  }
  return ai;
}

float cq_access_i(float *s, int n, int ri, int wi)
{
  int i = cq_index_i(n, ri, wi);
  return s[i];
}

void cq_increment_write_index(int n, int *wi)
{
  *wi += 1;
  if(*wi >= n) {
    *wi = 0;
  }
}

static InterfaceTable *ft;

enum Operation {
  map_move,
  map_add,
  map_sub,
  map_mul,
  map_div,
};

struct Mapping
{
  int src;
  int dst;
  enum Operation op;
  float gain;
};

#define Map_Offset 3
#define Map_Limit  64

struct RDelayMap : public Unit
{
  SndBuf *m_buf;
  int m_buf_id;
  struct Mapping m_map[Map_Limit];
  int m_map_n;
  float *m_signal;
  int m_signal_n;
  int m_write_index;
};

extern "C"
{
  void load(InterfaceTable *inTable);
  void RDelayMap_Ctor(RDelayMap *unit);
  void RDelayMap_next(RDelayMap *unit, int inNumSamples);
}

void sc3_ugen_get_buf(RDelayMap *unit, int n)
{
  int l_buf_id = (int)ZIN0(n);
  if(l_buf_id != unit->m_buf_id) {
    World *world = unit->mWorld;
    if(l_buf_id < 0 || l_buf_id >= (int)world->mNumSndBufs) {
      l_buf_id = 0;
    }
    unit->m_buf_id = l_buf_id;
    unit->m_buf = world->mSndBufs + l_buf_id;
  }
}

/* The input layout has the buffer index at zero the input signal at
   one, a dynamic update flag at two, and then any number of
   quadruples, each defining a single map, in the sequence: source,
   destination, operation, gain.  The locations are given in
   seconds.  */

void RDelayMap_Setup(RDelayMap *unit)
{
  int i, j;
  float location_max = 0.0;
  for(i = 0, j = Map_Offset; i < unit->m_map_n; i++, j += 4) {
    unit->m_map[i].src = (int)(ZIN0(j) * SAMPLERATE);
    unit->m_map[i].dst = (int)(ZIN0(j + 1) * SAMPLERATE);
    unit->m_map[i].op = (enum Operation)ZIN0(j + 2);
    unit->m_map[i].gain = ZIN0(j + 3);
    if(unit->m_map[i].src > location_max){
      location_max = unit->m_map[i].src;
    }
    if(unit->m_map[i].dst > location_max){
      location_max = unit->m_map[i].dst;
    }
  }
  unit->m_signal_n = (int) ceil(location_max) + 1;
}

void RDelayMap_Ctor(RDelayMap *unit)
{
  unit->m_buf = NULL;
  unit->m_buf_id = -1;
  unit->m_map_n = (unit->mNumInputs - Map_Offset) / 4;
  RDelayMap_Setup(unit);
  SETCALC(RDelayMap_next);
  unit->m_write_index = 0;
  unit->m_signal = NULL;
}

/* Mappings are made in order.  Negative values for input and output
   indices indicate the input and output signal boxes respectively.
   If the mapping is a move operation do not fetch the destination
   value as it is over-written and not required. */

float RDelayMap_step(RDelayMap *unit, float s)
{
  float v_out = 0.0;
  for(int i = 0; i < unit->m_map_n; i++){
    float v_src, v_dst;
    int dst_index_abs = 0;
    if(unit->m_map[i].dst >= 0){
      dst_index_abs = cq_index_i(unit->m_signal_n,
				 unit->m_map[i].dst,
				 unit->m_write_index);
    }
    if(unit->m_map[i].src < 0){
      v_src = unit->m_map[i].gain * s;
    } else {
      v_src =(unit->m_map[i].gain *
	      cq_access_i(unit->m_signal,
			  unit->m_signal_n,
			  unit->m_map[i].src,
			  unit->m_write_index));
    }
    if(unit->m_map[i].op == map_move){
      v_dst = v_src;
    } else {
      v_dst =(unit->m_map[i].dst < 0) ? v_out : unit->m_signal[dst_index_abs];
      switch(unit->m_map[i].op){
      case map_add: v_dst += v_src; break;
      case map_sub: v_dst -= v_src; break;
      case map_mul: v_dst *= v_src; break;
      case map_div: v_dst /= v_src; break;
      case map_move: break;
      }
    }
    if(unit->m_map[i].dst < 0){
      v_out = v_dst;
    } else {
      unit->m_signal[dst_index_abs] = v_dst;
    }
  }
  cq_increment_write_index(unit->m_signal_n,
			   &(unit->m_write_index));
  return v_out;
}

void RDelayMap_next(RDelayMap *unit, int inNumSamples)
{
  sc3_ugen_get_buf(unit, 0);
  if(!unit->m_buf->data) {
    unit->mDone = 1;
    ClearUnitOutputs(unit, inNumSamples);
    return;
  }
  if(unit->m_buf->channels != 1) {
    unit->mDone = 1;
    ClearUnitOutputs(unit, inNumSamples);
    return;
  }
  if((int)ZIN0(2) > 0) {
    RDelayMap_Setup(unit);
  }
  float *out = OUT(0);
  float *in = IN(1);
  if(unit->m_buf->frames - 1 < unit->m_signal_n){
    return;
  } else {
    unit->m_signal = unit->m_buf->data;
  }
  for(int i = 0; i < inNumSamples; i++){
    out[i] = RDelayMap_step(unit, in[i]);
  }
}

void load(InterfaceTable *inTable)
{
  ft = inTable;
  DefineSimpleUnit(RDelayMap);
}
