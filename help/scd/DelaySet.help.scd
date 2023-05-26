// DelaySet - three one second delays
var x = MouseX.kr(minval: 110, maxval: 660, warp: 0, lag: 0.1);
var y = MouseY.kr(minval: 0, maxval: 0.6, warp: 0, lag: 0.2);
var s = SinOsc.ar(freq: x, phase: 0, mul: y);
var d = DelaySet.ar(in: s, spec: [1, 1, 1/5, 2, 1/2, 1/10, 3, 1/3, 1/15]);
[s, d]

// DelaySet - n random delays
var x = MouseX.kr(minval: 110, maxval: 660, warp: 0, lag: 0.1);
var y = MouseY.kr(minval: 0, maxval: 0.4, warp: 0, lag: 0.2);
var s = SinOsc.ar(freq: x, phase: 0, mul: y);
var n = 10;
var a = { [5.0.rand, 0.2 + 0.8.rand, (1/40) + (1/40).rand] } ! n;
[s, DelaySet.ar(in: s, spec: a.flatten)]

// DelaySet - delay memory is allocated with rtalloc, adjust to observe allocation failure
var d = 10;
var x = MouseX.kr(minval: 110, maxval: 660, warp: 0, lag: 0.1);
var y = MouseY.kr(minval: 0, maxval: 0.6, warp: 0, lag: 0.2);
var s = SinOsc.ar(freq: x, phase: 0, mul: y);
[s, DelaySet.ar(in: s, spec: [d, 1, 1/5])] * 0.1
