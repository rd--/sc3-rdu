// Demultiplexer
var tr = Impulse.ar(4, 0);
var freq = TIRand.ar(48, 72, tr).midiCps;
var input = SinOsc.ar(freq, 0) * 0.5;
var numChannels = 4;
var selector = TIRand.ar(0, 4, tr);
Demultiplexer.ar(numChannels, input, selector).splay2
