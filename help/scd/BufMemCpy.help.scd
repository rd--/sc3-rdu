/*
Server plugin to memcpy data to a buffer from Osc byte-array data.
This is useful when:
1. running scsynth in a context where it has no or very limited access to a file system
2. running scsynth on a remote host which does not have access to the local file system
*/

// Allocate and copy a sine wavetable, assign to interpreter variable "b"
var bufferNumber = 10;
var numFrames = 128;
var numChannels = 1;
var sampleRate = 48000.0;
var bufferData = Wavetable.sineFill(numFrames / 2, [1]).as(Array);
var byteSwap = 0;
b = Buffer.alloc(
	s,
	numFrames,
	numChannels,
	BufMemCpy.message(
		bufferNumber,
		numFrames,
		numChannels,
		sampleRate,
		BufMemCpy.encodeFloat32Array(bufferData, true),
		byteSwap
	),
	bufferNumber
)

// Plot "b"
b.plot

// Play "b"
Osc.ar(b.bufnum, 440, 0) * 0.1
