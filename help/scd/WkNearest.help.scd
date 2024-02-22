// WkNearest
var k = 1;
var usePen = false;
var x = usePen.if { PenX(1) * 2 - 1 } { MouseX.kr(-1, 1, 0, 0.2) };
var y = usePen.if { PenY(1) * 2 - 1 } { MouseY.kr(-1, 1, 0, 0.2) };
var c = [0.707, -0.707, 0, 0.707, 0.707, 0, -0.707, 0.707, 0, -0.707, -0.707, 0];
var n = WkNearest.kr(k, 1, x, y, 0, c);
var z = [
	SinOsc.ar(333, 0),
	PinkNoise.ar,
	Saw.ar(111),
	Pulse.ar(222, 0.5)
] * 0.1;
Multiplexer.ar(n, z)
