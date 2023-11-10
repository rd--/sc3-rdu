// Demultiplexer ; sums to identity
var tr = Impulse.ar(4, 0);
var input = SinOsc.ar(440, 0);
var numChannels = 4;
var selector = TIRand.ar(0, 4, tr);
Demultiplexer.ar(numChannels, input, selector).sum * 0.1

// Demultiplexer
var tr = Impulse.ar(4, 0);
var freq = TIRand.ar(48, 72, tr).midiCps;
var input = SinOsc.ar(freq, 0) * Decay2.ar(tr, 0.05, 0.5);
var numChannels = 4;
var selector = TIRand.ar(0, 4, tr);
Demultiplexer.ar(numChannels, input, selector).splay2
