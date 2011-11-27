#define SC3_UGEN_STRUCT(name)			\
struct name : public Unit

#define SC3_UGEN_PROTOTYPES(name)			\
extern "C"						\
{							\
  void load ( InterfaceTable *inTable ) ;		\
  void name##_Ctor ( name *unit ) ;			\
  void name##_next ( name *unit , int inNumSamples ) ;	\
}

#define SC3_UGEN_PROTOTYPES_DTOR(name)			\
extern "C"						\
{							\
  void load ( InterfaceTable *inTable ) ;		\
  void name##_Ctor ( name *unit ) ;			\
  void name##_next ( name *unit , int inNumSamples ) ;	\
  void name##_Dtor ( name *unit ) ;			\
}

#define SC3_UGEN_CTOR(name)			\
void						\
name##_Ctor ( name *unit )

#define SC3_UGEN_NEXT(name)			\
void						\
name##_next ( name *unit , int inNumSamples )

#define SC3_UGEN_DECLARE_BUF			\
  SndBuf *m_buf ;				\
  int m_buf_id ;

#define SC3_UGEN_INIT_BUF			\
  unit->m_buf = NULL ;				\
  unit->m_buf_id = -1 ;

/* Monitored buffers are useful when the UGen needs to do considerable
   setup if the buffer changes.  The buffer ID and frame count are
   monitored.  */

#define SC3_UGEN_DECLARE_MONITORED_BUF		\
  SndBuf *m_buf ;				\
  int m_buf_id ;				\
  int m_prev_buf_id ;				\
  int m_prev_buf_frames ;

#define SC3_UGEN_INIT_MONITORED_BUF		\
  unit->m_buf = NULL ;				\
  unit->m_buf_id = -1 ;				\
  unit->m_prev_buf_id = -1 ;			\
  unit->m_prev_buf_frames = -1 ;

/* Set the unit field m_buf to point to the correct buffer, and
   m_buf_id to the buffer number. */

#define SC3_UGEN_GET_BUF(n)						\
  int l_buf_id = (int) ZIN0 ( n ) ;					\
  if ( l_buf_id != unit->m_buf_id ) {					\
    World *world = unit->mWorld;					\
    if ( l_buf_id < 0 || l_buf_id >= (int) world->mNumSndBufs ) {	\
      l_buf_id = 0;							\
    }									\
    unit->m_buf_id = l_buf_id ;						\
    unit->m_buf = world->mSndBufs + l_buf_id ;				\
  }

#define SC3_UGEN_CHECK_BUF_EXISTS		\
  if ( ! unit->m_buf->data ) {			\
    unit->mDone = 1 ;				\
    ClearUnitOutputs ( unit , inNumSamples ) ;	\
    return ;					\
}

#define SC3_UGEN_CHECK_BUF_CHANNELS(n)		\
  if ( unit->m_buf->channels != n ) {		\
    unit->mDone = 1 ;				\
    ClearUnitOutputs ( unit , inNumSamples ) ;	\
    return ;					\
}

#define SC3_UGEN_CHECK_BUF(n)			\
  SC3_UGEN_CHECK_BUF_EXISTS ;			\
  SC3_UGEN_CHECK_BUF_CHANNELS ( n ) ;

#define SC3_UGEN_ON_BUFFER_CHANGE(body)				\
  int buffer_changed = 0 ;					\
  if ( unit->m_buf_id != unit->m_prev_buf_id ) {		\
    unit->m_prev_buf_id = unit->m_buf_id ;			\
    buffer_changed = 1 ;					\
  }								\
  if ( unit->m_buf->frames != unit->m_prev_buf_frames ) {	\
    unit->m_prev_buf_frames = unit->m_buf->frames ;		\
    buffer_changed = 1 ;					\
  }								\
  if ( buffer_changed ) {					\
    fprintf ( stderr , "buffer changed\n" ) ;			\
    body ;							\
  }								\

#define SC3_UGEN_DISPLAY_BUF(fp)			\
  sc3_ugen_buf_display ( fp , unit->m_buf ) ;

#define SC3_UGEN_GET_CONTROLS(n)		\
  float controls[n] ;				\
  for ( int i = 0 ; i < n ; i++ ) {		\
    controls[i] = ZIN0 ( i ) ;			\
  }

#define SC3_UGEN_DTOR(name)			\
void						\
name##_Dtor ( name *unit )

#define SC3_UGEN_LOAD(name)			\
void load ( InterfaceTable *inTable )		\
{						\
  ft = inTable ;				\
  DefineSimpleUnit ( name ) ;			\
}

#define SC3_UGEN_LOAD_DTOR(name)		\
void load ( InterfaceTable *inTable )		\
{						\
  ft = inTable ;				\
  DefineDtorUnit ( name ) ;			\
}
