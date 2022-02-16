#include <SC_PlugIn.h>

#include "r-common/c/byte-order.c"
#include "r-common/c/memory.c"

static InterfaceTable* ft;

// Arguments are: 1. numFrames:int, 2. numChannels:int, 3, sampleRate:float, 4. bufferData:blob (copied directly into the buffer).
void BufMemCpy(World* world, struct SndBuf* buf, struct sc_msg_iter* msg) {
    int bufSize = buf->samples * sizeof(float);
    int numFrames = msg->geti();
    int numChannels = msg->geti();
    int numSamples = numFrames * numChannels;
    float sampleRate = msg->getf();
    int dataSize = msg->getbsize();
    if(((numFrames * numChannels * 4) == dataSize) && (dataSize == bufSize)) {
        buf->samplerate = (double)sampleRate;
        buf->sampledur = 1.0 / (double)sampleRate;
        buf->channels = numChannels;
        buf->samples = numSamples;
        buf->frames = numFrames;
        msg->getb((char *)(buf->data), dataSize);
        for(int i = 0; i < numSamples; i++) {
            u32 nextValue;
            u8 *nextAddress = (u8 *)(buf->data) + (i * 4);
            memcpy(&nextValue, nextAddress, 4);
            ntoh32_to_buf(nextAddress, nextValue);
        }
    }
}

PluginLoad(BufMemCpy) {
  ft = inTable;
  DefineBufGen("memcpy", BufMemCpy);
}
