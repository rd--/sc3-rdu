// DelaySetBuf - three one second delays ; note fixed sample rate (the server may not be running when the graph is constructed)
var b = LocalBuf(numFrames: 5 * 48000, numChannels: 1).clear;
var x = MouseX.kr(minval: 110, maxval: 660, warp: 0, lag: 0.1);
var y = MouseY.kr(minval: 0, maxval: 0.4, warp: 0, lag: 0.2);
var i = SinOsc.ar(freq: x, phase: 0, mul: y);
var d = DelaySetBuf.ar(bufnum: b, in: i, spec: [1, 1, 1/5, 2, 1/2, 1/10, 3, 1/3, 1/15]);
[i, d]
