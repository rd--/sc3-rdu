// Dx7Env - mouse control
var r1 = 35, r2 = 64, r3 = 55, r4 = 25;
var l1 = 99, l2 = 65, l3 = 75, l4 = 0;
var ol = 99;
var gate = MouseButton.kr(minval: 0, maxval: 1, lag: 0.2);
var data = 0;
SinOsc.ar(440, 0) * Dx7Env.ar(gate, data, r1, r2, r3, r4, l1, l2, l3, l4, ol) * 0.1
