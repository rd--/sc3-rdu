// TDistances
var t = Impulse.kr(50, 0);
var x = MouseX.kr(-1, 1, 0, 0.2);
var y = MouseY.kr(-1, 1, 0, 0.2);
var c = [0.707, -0.707, 0, 0.707, 0.707, 0, -0.707, 0.707, 0, -0.707, -0.707, 0];
var g = 0.1 / TDistances.kr(t, x, y, 0, c);
var z = [SinOsc.ar(333, 0), PinkNoise.ar, Saw.ar(111), Pulse.ar(222, 0.5)] * 0.1;
Splay.ar(z * g)
