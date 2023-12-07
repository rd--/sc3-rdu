/* https://github.com/asb2m10/dexed */
/* https://github.com/google/music-synthesizer-for-android */

#include <math.h>
#include <stdint.h>

#include "dx7/env.cc"
#include "dx7/exp2.cc"
#include "dx7/freqlut.cc"
#include "dx7/pitchenv.cc"

#include "r-common/c/float.h"
#include "r-common/c/int.h"
#include "r-common/c/memory.c"
#include "r-common/c/print.h"
#include "r-common/c/sf-sndfile.c"

struct RDX7Env {
	Env env;
	PitchEnv pitchenv;
	int r[4], l[4], ol;
	int mode; /* 0 = env ; 1 = pitchenv */
};

void RDX7Env_init(RDX7Env *d, f32 sr, int md)
{
	Freqlut::init(sr);
	Exp2::init();
	Env::init_sr(sr);
	PitchEnv::init(sr);
	d->mode = md;
}

/* (1 `shiftL` 24 == 0x1000000,0x8000 == 2^15,0x1000000 `shiftR` 9 == 0x8000) */
f32 dexed_to_f32(i32 x0)
{
	i32 x1 = x0 >> 4;
	i32 x2 = x1 < -0x1000000 ? 0x8000 : x1 >= 0x1000000 ? 0x7fff
														: (x1 >> 9);
	return ((f32)x2 / (f32)0x8000);
}

/* EG runs once per N samples, N = 64, sr=sample-rate, r=rate, l=level, ol=output-level */
void RDX7Env_write(const char *au_fn, RDX7Env *d, f32 sr,
	int r[4], int l[4], int ol0,
	f32 key_dur, f32 sus_dur)
{
	int n = (size_t)((key_dur + sus_dur) * sr) / N;
	f32 *s = (f32 *)xmalloc((size_t)n * sizeof(f32));
	int ol1 = Env::scaleoutlevel(ol0);
	int ol2 = ol1 << 5;
	printf("r=%d,%d,%d,%d l=%d,%d,%d,%d ol=%d\n", r[0], r[1], r[2], r[3], l[0], l[1], l[2], l[3], ol2);
	if (d->mode == 0) {
		d->env.init(r, l, ol2, 0);
	} else {
		d->pitchenv.set(r, l);
	}
	int key_up_n = int(key_dur * sr) / N;
	for (int i = 0; i < n; i++) {
		if (d->mode == 0) {
			char p;
			d->env.getPosition(&p);
			i32 s0 = d->env.getsample();
			i32 s1 = Exp2::lookup(s0 - (14 * (1 << 24)));
			f32 s2 = dexed_to_f32(s1) * 8; /* RANGE: 0=0 50=0.015 75=0.125 99=1 */
			dprintf("EG p=%d s0=%d s1=%d s2=%f\n", (int)p, s0, s1, s2);
			s[i] = s2;
		} else {
			char p;
			d->pitchenv.getPosition(&p);
			i32 s0 = d->pitchenv.getsample();
			f32 s1 = dexed_to_f32(s0) * 4;
			dprintf("PITCH EG p=%d s0=%d s1=%f\n", (int)p, s0, s1);
			s[i] = s1;
		}
		if (i == key_up_n) {
			if (d->mode == 0) {
				d->env.keydown(false);
			} else {
				d->pitchenv.keydown(false);
			}
		}
	}
	write_au_f32(au_fn, 1, n, sr / N, s);
	free(s);
}

/*
./rdx7-env-sf 0   66 55 44 33   99 50 75  0   99   1.0 2   /tmp/t.au
./rdx7-env-sf 1   99 77 88 77   50 99  0 75    0   1.5 2   /tmp/t.au
hsc3-sf-draw plain pbm t f f f f 200 0 /tmp/t.au /tmp/t.pbm
*/
int main(int argc, char **argv)
{
	if (argc != 14) {
		printf("rdx7-sf mode r1 r2 r3 r4 l1 l2 l3 l4 ol key-down-dur sustain-dur au-file\n");
		exit(1);
	}
	f32 sr = 48000, d1, d2;
	int r[4], l[4], ol;
	RDX7Env d;
	for (int i = 0; i < 4; i++) {
		r[i] = atoi(argv[i + 2]);
		l[i] = atoi(argv[i + 2 + 4]);
	}
	ol = atoi(argv[10]);
	d1 = atof(argv[11]);
	d2 = atof(argv[12]);
	RDX7Env_init(&d, sr, atoi(argv[1]));
	RDX7Env_write(argv[13], &d, sr, r, l, ol, d1, d2);
	return 0;
}
