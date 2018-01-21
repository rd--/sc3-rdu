typedef struct
{
  float location;
  float feed_forward;
  float feed_backward;
}
tap_t;

#define N_TAP 64

#define rdelayset_struct_common			\
  tap_t m_tap[N_TAP];                           \
  int m_tap_n;					\
  float *m_signal;				\
  int m_signal_n;				\
  int m_write_index;

/* The input layout has the buffer index at zero or not at all,the
   input signal at zero or one,and then any number of triples,each
   defining a single tap,in the sequence: location,feed forward
   gain,feed backward gain.  The location is given in seconds.  The
   signal array is allocated from the realtime memory store and is
   exactly long enough to support the furtherest tap.  */

#define rdelayset_ctor_common(offset)                   \
  float location_max = 0.0;                             \
  unit->m_tap_n =(unit->mNumInputs - offset) / 3;       \
  int i,j;                                              \
  for(i = 0,j = offset; i < unit->m_tap_n; i++,j+=3) {	\
    unit->m_tap[i].location = IN0(j) * SAMPLERATE;      \
    unit->m_tap[i].feed_forward = IN0(j + 1);		\
    unit->m_tap[i].feed_backward = IN0(j + 2);		\
    if(unit->m_tap[i].location > location_max) {        \
      location_max = unit->m_tap[i].location;           \
    }                                                   \
  }                                                     \
  unit->m_write_index = 0;                              \
  unit->m_signal_n =(int) ceil(location_max) + 1;       \
  unit->m_signal = NULL;

#define rdelayset_next_common(offset)				\
  float *out = OUT(0);                                          \
  float *in = IN(offset);					\
  for(int i = 0; i < inNumSamples; i++) {			\
    float s_out = 0.0;						\
    float s_feed_back = 0.0; 					\
    for(int j = 0; j < unit->m_tap_n; j++) {                    \
      s_out += cq_access_i(unit->m_signal,                      \
                           unit->m_signal_n,                    \
                           unit->m_tap[j].location,             \
                           unit->m_write_index);                \
      s_out = zapgremlins(s_out);				\
      s_feed_back += s_out * unit->m_tap[j].feed_backward;	\
      s_out *= unit->m_tap[j].feed_forward;			\
    }								\
    cq_update(unit->m_signal,                                   \
              unit->m_signal_n,                                 \
              in[i] + s_feed_back,                              \
              &(unit->m_write_index));                          \
    out[i] = s_out;						\
  }
