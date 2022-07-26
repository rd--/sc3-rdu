// ShufflerL - unary node
var o = SinOsc.ar([440, 441], 0) * 0.2;
var x = MouseX.kr(0.0001, 0.2, 0, 0.2);
var y = MouseY.kr(0.001, 0.2, 1, 0.2);
ShufflerL.ar(o, x, y)

// ShufflerL - parallel node banks
var n = 6;
var o = SinOsc.ar([440, 441], 0) * 0.2;
var x = MouseX.kr(0.0001, 0.2, 0, 0.2);
var y = MouseY.kr(0.001, 0.2, 1, 0.2);
ShufflerL.ar(o, x * { Rand.ir(0, 4) }.dup(n), y * { Rand.ir(0, 4) }.dup(n)).splay2
