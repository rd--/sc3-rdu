// pv_Split
var sz = 1024 * 2;
var z = SoundIn.ar(bus: 0);
var c0 = FFT.new(buffer: LocalBuf.new(numFrames: sz, numChannels: 1), in: z);
var c = PV_Split.new(bufferA: c0, bufferB: LocalBuf.new(numFrames: sz, numChannels: 1));
IFFT.new(c.at(0)) - IFFT.new(c.at(1))
