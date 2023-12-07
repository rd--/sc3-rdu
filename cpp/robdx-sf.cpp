/* https://github.com/2DaT/Obxd */
/* requires JUCE, -dev is not in debian testing */

#include <math.h>
#include <stdint.h>
#include <sys/time.h>

#include <cstring>
#include <utility>

#include "Obxd/Engine/Params.h"
#include "Obxd/Engine/SynthEngine.h"

#include "r-common/c/cfile.c"
#include "r-common/c/clip.c"
#include "r-common/c/float.h"
#include "r-common/c/memory.c"
#include "r-common/c/print.h"
#include "r-common/c/sf-sndfile.c"
#include "r-common/c/signal-interleave.c"
#include "r-common/c/vector.c"

struct ROBDX {
	SynthEngine synth;
	ObxdParams param;
};

void ROBDX_init(ROBDX *d, f32 sr)
{
	d->synth.setSampleRate(sr);
	/*d->param.setDefaultValues();*/
}

/* N = 64 */
void ROBDX_write(const char *au_fn, ROBDX *d, f32 sr, int mnn, int vel, f32 key_dur, f32 sus_dur)
{
	int n = (size_t)((key_dur + sus_dur) * sr);
	f32 *s = (f32 *)xmalloc((size_t)n * sizeof(f32) * 2);
	f32 *s1 = s;
	f32 *s2 = s + ((size_t)n * sizeof(f32));
	d->synth.procNoteOn(mnn, ((float)vel) / 127.0);
	int key_up_n = int(key_dur * sr);
	for (int i = 0; i < n; i++) {
		if (i == key_up_n) {
			d->synth.procNoteOff(mnn);
		}
		d->synth.processSample(s1 + i, s2 + i);
	}
	f32 *o = (f32 *)xmalloc((size_t)n * sizeof(f32) * 2);
	signal_interleave(o, s, n, 2);
	write_au_f32(au_fn, 2, n, sr, o);
	free(s);
}

void ROBDX_free(ROBDX *d)
{
}

/* robdx-sf _ 60 99 3 3 /tmp/obdx.au */
int main(int argc, char **argv)
{
	if (argc != 7) {
		printf("robdx-sf voice-data midi-note velocity key-down-dur sustain-dur au-file\n");
		exit(1);
	}
	f32 sr = 48000;
	ROBDX d;
	ROBDX_init(&d, sr);
	ROBDX_write(argv[6], &d, sr, atoi(argv[2]), atoi(argv[3]), atof(argv[4]), atof(argv[5]));
	ROBDX_free(&d);
	return 0;
}
