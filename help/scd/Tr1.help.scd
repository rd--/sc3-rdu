// Tr1 ; c.f. Tr
[Tr1.ar(SinOsc.ar(10, 0)), Impulse.ar(10, 0)] * 0.1

// Tr1
PinkNoise.ar() * Decay2.ar(Tr1.ar(SinOsc.ar([13, 19], 0)), 0.01, 0.1) * 0.1
