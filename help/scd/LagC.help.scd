// LagC
var x = MouseX.kr(220, 440, 'linear', 0.2);
SinOsc.ar([x, LagC.kr(x, 1, 0, 5, 0)], 0) * 0.1
