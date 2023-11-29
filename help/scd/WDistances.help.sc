// WDistances
var x = MouseX.kr(-1, 1, 0, 0.2);
var y = MouseY.kr(-1, 1, 0, 0.2);
var c = [-45, 45, 135, -135].collect { | each |
	SphericalCoordinate(1, pi / 2, each.degreesToRadians).asCartesianCoordinate.asArray
}.flat;
var g = 0.5 / WDistances.kr(1, x, y, 0, c);
var z = HPF.ar(PinkNoise.ar(), ([1, 2, 3, 4] * 12 + 36).midicps);
Splay2.ar(z * g)
