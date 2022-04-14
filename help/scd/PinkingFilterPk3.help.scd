// PinkingFilterPk3
var amp = MouseX.kr(0.01, 0.1, 1, 0.2);
PinkingFilterPk3.ar(WhiteNoise.ar() * 0.1) * amp

// PinkingFilterPk3 ; c.f. WhiteNoise
var amp = MouseX.kr(0.01, 0.1, 1, 0.2);
[PinkingFilterPk3.ar(WhiteNoise.ar() * 0.1), WhiteNoise.ar() * 0.1] * amp

// PinkingFilterPk3 ; c.f. PinkNoise
var amp = MouseX.kr(0.01, 0.1, 1, 0.2);
[PinkingFilterPk3.ar(WhiteNoise.ar() * 0.1), PinkNoise.ar()] * amp

