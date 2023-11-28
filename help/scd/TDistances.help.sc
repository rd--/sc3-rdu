// TDistances
var t = Impulse.kr(60, 0);
var x = MouseX.kr(-1, 1, 0, 0.2);
var y = MouseY.kr(-1, 1, 0, 0.2);
var c = [-45, 45, 135, -135].collect { | each |
	SphericalCoordinate(1, pi / 2, each.degreesToRadians).asCartesianCoordinate.asArray
}.flat;
var g = 0.1 / TDistances.kr(t, x, y, 0, c);
var z = [SinOsc.ar(333, 0), PinkNoise.ar, Saw.ar(111), Pulse.ar(222, 0.5)] * 0.1;
Splay2.ar(z * g)
