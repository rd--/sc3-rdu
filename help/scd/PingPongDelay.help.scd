// PingPongDelay
var left = Decay2.ar(Impulse.ar(0.6, 0) * 0.25, 0.01, 0.25) * SinOsc.ar(SinOsc.ar(3.7, 0) * 200 + 500);
var right = Decay2.ar(Impulse.ar(0.5, 0) * 0.25, 0.01, 0.25) * Resonz.ar(PinkNoise.ar() * 4, SinOsc.ar(2.7, 0) * 1000 + 2500, 0.2);
PingPongDelay.ar(left, right, 0.5, MouseX.kr(0.1, 0.5, 0, 0.2), 0.7)
