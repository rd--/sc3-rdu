// TSort ; octaves, either low is left and high is right else both are stereo ; audio rate
var tr = Impulse.ar(1, 0);
var freq = { TIRand.ar(1, 7, tr) } ! 2 * [55, 110];
SinOsc.ar([freq, TSort.ar(tr, freq)], 0).sum * 0.1

// TSort ; octaves, either low is left and high is right else both are stereo ; control rate
var tr = Impulse.kr(1, 0);
var freq = { TIRand.kr(1, 7, tr) } ! 2 * [55, 110];
SinOsc.ar([freq, TSort.kr(tr, freq)], 0).sum * 0.1

// TSort ; seven sin tones across stereo field ; unsorted tone is mixed quieter
var tr = Impulse.kr(1, 0);
var freq = { TChoose.kr(tr, [60, 62, 64, 65, 67, 69, 71, 72].midiCps) } ! 7;
(SinOsc.ar([freq, TSort.kr(tr, freq)], 0) * [0.05, 0.1]).sum.splay2
