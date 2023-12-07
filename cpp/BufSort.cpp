#include <stdlib.h> // qsort

#include <SC_PlugIn.h>

#include "r-common/c/compare.h"

static InterfaceTable *ft;

void BufSort(World *world, struct SndBuf *buf, struct sc_msg_iter *msg)
{
	int numChannels = buf->channels;
	int numFrames = buf->frames;
	if (numChannels == 1) {
		qsort(buf->data, numFrames, sizeof(float), compare_float);
	} else {
		Print("BufSort.sort: illegal buffer, only non-empty single channel buffers may be sorted");
	}
}

PluginLoad(BufSort)
{
	ft = inTable;
	DefineBufGen("sort", BufSort);
}
