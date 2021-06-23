#define rdu_prototypes(name)                            \
extern "C"                                              \
{                                                       \
    void name##_Ctor(name *unit);                       \
    void name##_next(name *unit,int inNumSamples);      \
}

#define rdu_prototypes_dtor(name)                       \
extern "C"                                              \
{                                                       \
    void name##_Ctor(name *unit);                       \
    void name##_next(name *unit,int inNumSamples);      \
    void name##_Dtor(name *unit);                       \
}

#define rdu_declare_buf(nm)                    \
    SndBuf *m_buf_##nm;                        \
    uint32 m_buf_id_##nm

#define rdu_init_buf(nm)                        \
    unit->m_buf_##nm = NULL;                    \
    unit->m_buf_id_##nm = UINT32_MAX

/* Monitored buffers are useful when the UGen needs to do considerable
   setup if the buffer changes.  The buffer ID and frame count are
   monitored.  */

#define rdu_declare_monitored_buf(nm)           \
    SndBuf *m_buf_##nm;                         \
    uint32 m_buf_id_##nm;                       \
    uint32 m_prev_buf_id_##nm;                  \
    int m_prev_buf_frames_##nm

#define rdu_init_monitored_buf(nm)                   \
    unit->m_buf_##nm = NULL;                         \
    unit->m_buf_id_##nm = UINT32_MAX;                \
    unit->m_prev_buf_id_##nm = UINT32_MAX;           \
    unit->m_prev_buf_frames_##nm = -1

/* Set the unit field m_buf_##nm to point to the correct buffer, and
   m_buf_id_##nm to the buffer number.  Handles local buffers.  */

#define rdu_get_buf(nm,n)                                               \
    uint32 l_buf_id_##nm = (uint32) sc_max(0.f,IN0(n));                 \
    if(l_buf_id_##nm != unit->m_buf_id_##nm) {                          \
        World *l_world = unit->mWorld;                                  \
        if(l_buf_id_##nm < 0) {                                         \
            l_buf_id_##nm = 0;                                          \
        }                                                               \
        if (l_buf_id_##nm >= l_world->mNumSndBufs) {                    \
            int l_loc_buf = l_buf_id_##nm - l_world->mNumSndBufs;       \
            Graph *l_parent = unit->mParent;                            \
            if(l_loc_buf <= l_parent->localBufNum) {                    \
                unit->m_buf_id_##nm = l_buf_id_##nm;                    \
                unit->m_buf_##nm = l_parent->mLocalSndBufs + l_loc_buf; \
            } else {                                                    \
                unit->m_buf_id_##nm = 0;                                \
                unit->m_buf_##nm = l_world->mSndBufs;                   \
            }                                                           \
        } else {                                                        \
            unit->m_buf_id_##nm = l_buf_id_##nm;                        \
            unit->m_buf_##nm = l_world->mSndBufs + l_buf_id_##nm;       \
        }                                                               \
    }

#define rdu_check_buf_exists(nm)                     \
    if(!unit->m_buf_##nm->data) {                    \
        unit->mDone = 1;                             \
        ClearUnitOutputs(unit,inNumSamples);         \
        printf("rdu: !buf_exists\n");                \
        return;                                      \
    }

#define rdu_check_buf_channels(nm,n)                 \
    if(unit->m_buf_##nm->channels != n) {            \
        unit->mDone = 1;                             \
        ClearUnitOutputs(unit,inNumSamples);         \
        printf("rdu: !buf_channels\n");              \
        return;                                      \
    }

#define rdu_check_buf(nm,n)                        \
    rdu_check_buf_exists(nm);                      \
    rdu_check_buf_channels(nm,n);

#define rdu_on_buffer_change(nm,body)                                   \
    int buffer_changed_##nm = 0;                                        \
    if(unit->m_buf_id_##nm != unit->m_prev_buf_id_##nm) {               \
        unit->m_prev_buf_id_##nm = unit->m_buf_id_##nm;                 \
        buffer_changed_##nm = 1;                                        \
    }                                                                   \
    if(unit->m_buf_##nm->frames != unit->m_prev_buf_frames_##nm) {      \
        unit->m_prev_buf_frames_##nm = unit->m_buf_##nm->frames;        \
        buffer_changed_##nm = 1;                                        \
    }                                                                   \
    if(buffer_changed_##nm) {                                           \
        printf("rdu: buffer changed\n");                                \
        body;                                                           \
    }

#define rdu_get_controls(n)                     \
    float controls[n];                          \
    for(int i = 0; i < n; i++) {                \
        controls[i] = IN0(i);                   \
    }

#define rdu_load(name)                          \
PluginLoad(name)                                \
{                                               \
    ft = inTable;                               \
    DefineSimpleUnit(name);                     \
}

#define rdu_load_dtor(name)                     \
PluginLoad(name)                                \
{                                               \
    ft = inTable;                               \
    DefineDtorUnit(name);                       \
}

#define rdu_load_dtor_noalias(name)             \
PluginLoad(name)                                \
{                                               \
    ft = inTable;                               \
    DefineDtorCantAliasUnit(name);                       \
}

#define rdu_zero_outputs()                              \
    for (uint32 _i = 0; _i < unit->mNumOutputs; _i++) { \
        float *_b = OUT(_i);                            \
        for (int _j = 0; _j < inNumSamples; _j++) {     \
            _b[_j] = 0.0;                               \
        }                                               \
    }

#define rdu_define_pv_unit(ft,name) \
  (*ft->fDefineUnit)(#name, sizeof(PV_Unit), (UnitCtorFunc)&name##_Ctor, 0, 0);
