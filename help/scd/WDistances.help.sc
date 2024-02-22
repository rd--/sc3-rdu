// WDistances
var usePen = true;
var w = 1;
var x = usePen.if { PenX(1) * 2 - 1 } { MouseX.kr(-1, 1, 0, 0.2) };
var y = usePen.if { PenY(1) * 2 - 1 } { MouseY.kr(-1, 1, 0, 0.2) };
var c = [0.707, -0.707, 0, 0.707, 0.707, 0, -0.707, 0.707, 0, -0.707, -0.707, 0];
var g = 0.5 / WDistances.kr(w, x, y, 0, c);
var z = HPF.ar(PinkNoise.ar(), ([1, 2, 3, 4] * 12 + 36).midicps);
Splay.ar(z * g)
