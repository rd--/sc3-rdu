#define rdu_prototypes(name)                            \
extern "C"                                              \
{                                                       \
  void load(InterfaceTable *inTable);                   \
  void name##_Ctor(name *unit);                         \
  void name##_next(name *unit,int inNumSamples);        \
}

#define rdu_prototypes_dtor(name)                       \
extern "C"                                              \
{                                                       \
  void load(InterfaceTable *inTable);                   \
  void name##_Ctor(name *unit);                         \
  void name##_next(name *unit,int inNumSamples);        \
  void name##_Dtor(name *unit);                         \
}

#define rdu_declare_buf                         \
  SndBuf *m_buf;                                \
  uint32 m_buf_id;

#define rdu_init_buf                            \
  unit->m_buf = NULL;                           \
  unit->m_buf_id = UINT32_MAX;

/* Monitored buffers are useful when the UGen needs to do considerable
   setup if the buffer changes.  The buffer ID and frame count are
   monitored.  */

#define rdu_declare_monitored_buf               \
  SndBuf *m_buf;                                \
  uint32 m_buf_id;                              \
  uint32 m_prev_buf_id;                         \
  int m_prev_buf_frames;

#define rdu_init_monitored_buf                  \
  unit->m_buf = NULL;                           \
  unit->m_buf_id = UINT32_MAX;                  \
  unit->m_prev_buf_id = UINT32_MAX;             \
  unit->m_prev_buf_frames = -1;

/* Set the unit field m_buf to point to the correct buffer, and
   m_buf_id to the buffer number.  Handles local buffers.  */

#define rdu_get_buf(n)                                             \
    uint32 l_buf_id = (uint32) sc_max(0.f,ZIN0(n));                \
    if(l_buf_id != unit->m_buf_id) {                               \
        World *l_world = unit->mWorld;                             \
        if(l_buf_id < 0) {                                         \
            l_buf_id = 0;                                          \
        }                                                          \
        if (l_buf_id >= l_world->mNumSndBufs) {                    \
            int l_loc_buf = l_buf_id - l_world->mNumSndBufs;       \
            Graph *l_parent = unit->mParent;                       \
            if(l_loc_buf <= l_parent->localBufNum) {               \
                unit->m_buf_id = l_buf_id;                         \
                unit->m_buf = l_parent->mLocalSndBufs + l_loc_buf; \
            } else {                                               \
                unit->m_buf_id = 0;                                \
                unit->m_buf = l_world->mSndBufs;                   \
            }                                                      \
        } else {                                                   \
            unit->m_buf_id = l_buf_id;                             \
            unit->m_buf = l_world->mSndBufs + l_buf_id;            \
        }                                                          \
    }

#define rdu_check_buf_exists                    \
  if(!unit->m_buf->data) {                      \
    unit->mDone = 1;                            \
    ClearUnitOutputs(unit,inNumSamples);        \
    printf("rdu: !buf_exists\n");               \
    return;                                     \
  }

#define rdu_check_buf_channels(n)               \
  if(unit->m_buf->channels != n) {              \
    unit->mDone = 1;                            \
    ClearUnitOutputs(unit,inNumSamples);        \
    printf("rdu: !buf_channels\n");     \
    return;                                     \
  }

#define rdu_check_buf(n)                        \
  rdu_check_buf_exists;                         \
  rdu_check_buf_channels(n);

#define rdu_on_buffer_change(body)                      \
  int buffer_changed = 0;                               \
  if(unit->m_buf_id != unit->m_prev_buf_id) {           \
    unit->m_prev_buf_id = unit->m_buf_id;               \
    buffer_changed = 1;                                 \
  }                                                     \
  if(unit->m_buf->frames != unit->m_prev_buf_frames) {  \
    unit->m_prev_buf_frames = unit->m_buf->frames;      \
    buffer_changed = 1;                                 \
  }                                                     \
  if(buffer_changed) {                                  \
    printf("rdu: buffer changed\n");                    \
    body;                                               \
  }

#define rdu_get_controls(n)                     \
  float controls[n];                            \
  for(int i = 0; i < n; i++) {                  \
    controls[i] = ZIN0(i);                      \
  }

#define rdu_load(name)                          \
PluginLoad(name)                                \
{                                               \
  ft = inTable;                                 \
  DefineSimpleUnit(name);                       \
}

#define rdu_load_dtor(name)                     \
PluginLoad(name)                                \
{                                               \
  ft = inTable;                                 \
  DefineDtorUnit(name);                         \
}

#define rdu_zero_outputs()                              \
  for (uint32 _i = 0; _i < unit->mNumOutputs; _i++) {   \
    float *_b = OUT(_i);                                \
    for (int _j = 0; _j < inNumSamples; _j++) {         \
      _b[_j] = 0.0;                                     \
    }                                                   \
  }
