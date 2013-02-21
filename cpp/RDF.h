#include "SC_PlugIn.h"

struct RDF : public Unit {
  bool m_rdf_status;
  void *m_rdf_fd;
  void* (*m_rdf_init)(void *, int);
  void (*m_rdf_step)(void *, int, int);
  void *m_rdf_st;
};

#define df_world RDF
#define w_state(w,g) (w)->m_rdf_st
#define w_sr(w) (w)->mRate->mSampleRate
#define w_c_get1(w,i) (w)->mWorld->mControlBus[i]
#define w_out1(w,i,n) (w)->mOutBuf[0][(i)]+=(n)
#define w_out2(w,i,n1,n2) {w_out1(w,i,n1);w_out1(w,i+1,n2);}
#define w_b_read1(w,b,i) (w)->mWorld->mSndBufs[(b)].data[(i)]
#define w_b_write1(w,b,i,n) (w)->mWorld->mSndBufs[(b)].data[(i)]=(n)
