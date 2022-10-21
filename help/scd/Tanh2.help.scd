// Tanh2
var steepness = MouseX.kr(0.75, 1.5, 0, 0.2);
var range = MouseY.kr(0.75, 1.5, 0, 0,2);
Tanh2(SinOsc.ar(440, 0), steepness, range) * 0.1
