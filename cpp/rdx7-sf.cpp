/* https://github.com/asb2m10/dexed */
/* https://github.com/google/music-synthesizer-for-android */

#include <math.h>
#include <stdint.h>

#include "dx7/aligned_buf.h"
#include "dx7/controllers.h"
#include "dx7/dx7note.cc"
#include "dx7/env.cc"
#include "dx7/exp2.cc"
#include "dx7/fm_core.cc"
#include "dx7/fm_op_kernel.cc"
#include "dx7/freqlut.cc"
#include "dx7/lfo.cc"
#include "dx7/pitchenv.cc"
#include "dx7/sin.cc"

#include "dx7/EngineMkI.cpp"

#include "c-common/cfile.c"
#include "c-common/clip.c"
#include "c-common/dx7.c"
#include "c-common/float.h"
#include "c-common/memory.c"
#include "c-common/print.h"
#include "c-common/sf-sndfile.c"
#include "c-common/vector.c"

/* DEXED adds switches for each OP, this set them, 0x3F turns everything on */
void unpack_op_switch(Controllers *c,uint8_t x) {
    c->opSwitch[5] = ((x >> 5) &1) + 48;
    c->opSwitch[4] = ((x >> 4) &1) + 48;
    c->opSwitch[3] = ((x >> 3) &1) + 48;
    c->opSwitch[2] = ((x >> 2) &1) + 48;
    c->opSwitch[1] = ((x >> 1) &1) + 48;
    c->opSwitch[0] = ((x >> 0) &1) + 48;
}

void ctl_init(Controllers *c)
{
    c->values_[kControllerPitch] = 0x2000;
    c->values_[kControllerPitchRange] = 3;
    c->values_[kControllerPitchStep] = 0;
    c->modwheel_cc = 0;
    c->foot_cc = 0;
    c->breath_cc = 0;
    c->aftertouch_cc = 0;
    c->masterTune = 0;
    c->refresh();
    c->core = new EngineMkI; /* ALLOC - FmCore */
    unpack_op_switch(c,0x3F);
}

#define buf_zero(b,n) for(int _i = 0; _i < n; _i++) {b.get()[_i] = 0;}

struct RDX7
{
    Controllers controllers;
    Lfo lfo;
    Dx7Note *dx7_note;
    uint8_t dx7_data[155];
};

void RDX7_init(RDX7 *d,f32 sr)
{
    Freqlut::init(sr);
    Exp2::init();
    Tanh::init();
    Sin::init();
    Lfo::init(sr);
    PitchEnv::init(sr);
    Env::init_sr(sr);
    ctl_init(&(d->controllers));
    d->dx7_note = new Dx7Note; /* NON-RT */
}

/* N = 64 */
void RDX7_write(const char *au_fn,RDX7 *d,f32 sr,const uint8_t *vc,int mnn,int vel,f32 key_dur,f32 sus_dur)
{
    memcpy(d->dx7_data,vc,155);
    d->lfo.reset(d->dx7_data + 137);
    int n = (size_t)((key_dur + sus_dur) * sr);
    f32 *s = (f32*)xmalloc((size_t)n * sizeof(f32));
    d->lfo.keydown();
    d->dx7_note->init(d->dx7_data, mnn + (int)(d->dx7_data[144]) - 24, 0, vel);
    if (d->dx7_data[136]) {
        d->dx7_note->oscSync();
    }
    int key_up_n = int(key_dur * sr);
    for (int i = 0; i < n; i += N) {
        dprintf("RDX7: FRAME: i=%d\n",i);
        int32_t lfovalue = d->lfo.getsample();
        int32_t lfodelay = d->lfo.getdelay();
        AlignedBuf<int32_t, N> audiobuf;
        buf_zero(audiobuf,N);
        d->dx7_note->compute(audiobuf.get(), lfovalue, lfodelay, &(d->controllers));
        for (int j = 0; j < N; j++) {
            if(i + j == key_up_n) {
                d->dx7_note->keyup();
            }
            int32_t val = audiobuf.get()[j];
            val = val >> 4;
            int clip_val = val < -(1 << 24) ? 0x8000 : val >= (1 << 24) ? 0x7fff : val >> 9;
            f32 f = clipf32 ((f32)clip_val / (f32)0x8000,-1,1);
            s[i + j] = f;
            audiobuf.get()[j] = 0;
        }
    }
    write_au_f32(au_fn,1,n,sr,s);
    free(s);
}

void RDX7_free(RDX7 *d)
{
    delete d->dx7_note;
}

/* rdx7-sf /home/rohan/sw/hsc3-data/data/yamaha/dx7/rom/DX7-ROM1A.syx 2 60 99 3 3 /tmp/dx7.au */
int main(int argc, char **argv)
{
    if(argc != 8) {
        printf("rdx7-sf syx-file voice-ix midi-note velocity key-down-dur sustain-dur au-file\n");
        exit(1);
    }
    f32 sr = 48000;
    uint8_t bnk[4960];
    char nm[11];
    dx7_syx_load(argv[1],bnk);
    uint8_t *vc = bnk + (155 * (atoi(argv[2]) - 1));
    dx7_voice_name_cstr(vc,nm);
    printf("VOICE=%s\n",nm);
    RDX7 d;
    RDX7_init(&d,sr);
    RDX7_write(argv[7],&d,sr,vc,atoi(argv[3]),atoi(argv[4]),atof(argv[5]),atof(argv[6]));
    RDX7_free(&d);
    return 0;
}
