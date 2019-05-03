/* https://github.com/asb2m10/dexed */
/* https://github.com/google/music-synthesizer-for-android */

#include <math.h>
#include <stdint.h>

#include "dx7/env.cc"
#include "dx7/exp2.cc"

#include "c-common/clip.c"
#include "c-common/memory.c"
#include "c-common/sf-sndfile.c"
#include "c-common/vector.c"

struct RDX7Env
{
    Env env;
    int r[4],l[4],ol;
};

void RDX7Env_init(RDX7Env *d,f32 sr)
{
    Exp2::init();
    Env::init_sr(sr);
}

float to_f32(int32_t x)
{
    x = x >> 4;
    int32_t clip_x = x < -(1 << 24) ? 0x8000 : x >= (1 << 24) ? 0x7fff : x >> 9;
    return ((f32)clip_x / (f32)0x8000);
}

/* N = 64 */
void RDX7Env_write(const char *au_fn,RDX7Env *d,f32 sr,f32 key_dur,f32 sus_dur)
{
    int n = (size_t)((key_dur + sus_dur) * sr);
    f32 *s = (f32*)xmalloc((size_t)n * sizeof(f32));
    int r[4] = {50,50,50,50}, l[4] = {99,79,59,0}, ol = 99;
    ol = Env::scaleoutlevel(ol);
    ol = ol << 5;
    printf("r=%d,%d,%d,%d l=%d,%d,%d,%d ol=%d\n",r[0],r[1],r[2],r[3],l[0],l[1],l[2],l[3],ol);
    d->env.init(r,l,ol,0);
    int key_up_n = int(key_dur * sr);
    f32 prev_level_f = 0;
    for (int i = 0; i < n; i += N) {
        char pos;
        d->env.getPosition(&pos);
        int32_t env_sig = d->env.getsample();
        int32_t next_level = Exp2::lookup(env_sig - (14 * (1 << 24)));
        f32 next_level_f = to_f32(next_level);
        f32 incr = (next_level_f - prev_level_f) / (f32)N;
        printf("pos=%d env_sig=%d next_level=%d=%f incr=%f\n",
               (int)pos,env_sig,next_level,next_level_f,incr);
        for (int j = 0; j < N; j++) {
            s[i + j] = prev_level_f;
            prev_level_f += incr;
            if(i + j == key_up_n) {
                d->env.keydown(false);
            }
        }
        prev_level_f = next_level_f;
    }
    write_au_f32(au_fn,1,n,sr,s);
    free(s);
}

int main(int argc, char **argv)
{
/*
    if(argc != 8) {
        printf("rdx7-sf r1 r2 r3 r4 l1 l2 l3 l4 ol key-down-dur sustain-dur au-file\n");
        exit(1);
    }
*/
    f32 sr = 48000;
    RDX7Env d;
    RDX7Env_init(&d,sr);
    RDX7Env_write(argv[1],&d,sr,1,2);
    return 0;
}
