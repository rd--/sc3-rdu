// TracePlay
var b = LocalBuf.newFrom([0, -1, 1/4, 0, 1/4, 0, 1/2, 0, 1/2, 1, 1/4, 0, 3/4, 0, 0, 0, 1, -1, 1/4, 0]);
var x = TracePlay.kr(b, 4, 0.5, 0);
Pan2.ar(SinOsc.ar(440, 0, 0.5), x, 0.1)

