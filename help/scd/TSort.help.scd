// TSort - octaves, either low is left and high is right else both are stereo
var tr = Impulse.kr(1, 0);
var freq = #[55, 110] * { TIRand.kr(1, 7, tr) }.dup(2);
SinOsc.ar([freq, TSort.kr(tr, freq)], 0).sum * 0.1

// TSort - seven sin tones across stereo field ; unsorted tone is mixed quieter
var tr = Impulse.kr(1, 0);
var freq = { TChoose.kr(tr, #[60, 62, 64, 65, 67, 69, 71, 72].midicps) }.dup(7);
(SinOsc.ar([freq, TSort.kr(tr, freq)], 0) * [0.05, 0.1]).splay2
