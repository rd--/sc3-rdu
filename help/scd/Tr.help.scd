// Tr ; c.f. Tr1
[Tr.ar(SinOsc.ar(10, 0)) > 0, Impulse.ar(10, 0)] * 0.1

// Tr
PinkNoise.ar() * Decay2.ar(Tr.ar(SinOsc.ar([13, 19], 0)) > 0, 0.01, 0.1) * 0.1
