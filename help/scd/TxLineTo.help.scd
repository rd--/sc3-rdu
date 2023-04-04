// TxLineTo ; ramp every trigger ; pseudo-ugen
var trig = Impulse.kr(1/4, 0);
var f = { arg trig; TExpRand.kr(110, 440, trig) };
SinOsc.ar(TxLineTo.kr(f, 4, trig),0) * 0.1
