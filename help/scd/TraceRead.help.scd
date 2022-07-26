// TraceRead - diamond trace, equal time increments, X element is (-1 0 1 0 -1)
var b = LocalBuf.newFrom([0, -1, 1/4, 0, 1/4, 0, 1/2, 0, 1/2, 1, 1/4, 0, 3/4, 0, 0, 0, 1, -1, 1/4, 0]);
var x = TraceRead.kr(b, 4, LFSaw.kr(1, 0, 1/2, 1/2), 1);
Pan2.ar(SinOsc.ar(440, 0, 0.5), x, 0.1)

// TraceRead - diamond trace, equal time increments, X element is (1/4 1/2 1/4 0 1/4)
var b = LocalBuf.newFrom([0, -1, 1/4, 0, 1/4, 0, 1/2, 0, 1/2, 1, 1/4, 0, 3/4, 0, 0, 0, 1, -1, 1/4, 0]);
var x = TraceRead.kr(b, 4, LFSaw.kr(1, 0, 1/2, 1/2), 1);
var y = TraceRead.kr(b, 4, LFSaw.kr(1, 0, 1/2, 1/2), 2);
Pan2.ar(SinOsc.ar(440, 0, 0.1), x, y)
