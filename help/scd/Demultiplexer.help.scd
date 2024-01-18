// Demultiplexer ; sums to identity
var tr = Impulse.ar(4, 0);
var input = SinOsc.ar(440, 0);
var numChannels = 4;
var selector = TIRand.ar(0, numChannels - 1, tr);
Demultiplexer.ar(numChannels, input, selector).sum * 0.1

// Demultiplexer
var tr = Impulse.ar(4, 0);
var freq = TIRand.ar(48, 72, tr).midicps;
var env = Decay2.ar(tr, 1 / 13, 1 / 2) * 0.5;
var input = SinOsc.ar(freq, 0) * env;
var numChannels = 4;
var selector = TIRand.ar(0, numChannels - 1, tr);
Splay.ar(Demultiplexer.ar(numChannels, input, selector))
