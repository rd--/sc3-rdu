// Multiplexer (ie. Select) ; identity
var numChannels = 4;
var tr = Impulse.ar(4, 0);
var selector = TIRand.ar(0, numChannels - 1, tr);
var env = Decay2.ar(tr, 1 / 11, 1 / 3) / 5;
var inputArray = SinOsc.ar({ Rand(48, 72).midiCps } ! numChannels, 0) * env;
var signalA = Multiplexer.ar(selector, inputArray);
var signalB = Select.ar(selector, inputArray);
var signalC = Demultiplexer.ar(numChannels, signalA, selector).sum;
[signalA, signalB, signalC].splay2
