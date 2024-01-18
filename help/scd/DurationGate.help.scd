// DurationGate ; audio rate
var x = LFNoise2.ar(1).exprange(0.025, 2);
var gate = DurationGate.ar(x);
var trig = Trig1.ar(gate, SampleDur.ir);
var freq = LFNoise2.ar(2).range(111, 555);
var latchFreq = Latch.ar(freq, trig);
SinOsc.ar([freq, latchFreq], 0) * 0.1

// DurationGate ; audio rate, control rate input
var x = MouseX.kr(0.025, 2, 1, 0.2);
var gate = DurationGate.ar(x);
var trig = Trig1.ar(gate, SampleDur.ir);
var freq = LFNoise2.ar(2).range(111, 555);
var latchFreq = Latch.ar(freq, trig);
SinOsc.ar([freq, latchFreq], 0) * 0.1

// DurationGate ; control rate
var x = MouseX.kr(0.1, 1, 1, 0.2);
var gate = DurationGate.kr(x);
var trig = Trig1.kr(gate, ControlDur.ir);
var freq = LFNoise2.ar(1).range(111, 555);
var latchFreq = Latch.kr(freq, trig);
SinOsc.ar([freq, latchFreq], 0) * 0.1
