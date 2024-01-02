// Hold ; audio rate
var freq = LFNoise2.ar(2).range(111, 555);
var latchFreq = Hold.ar(freq, MouseX.kr(0.025, 2, 1, 0.2));
SinOsc.ar([freq, latchFreq], 0) * 0.1

// Hold ; control rate
var freq = LFNoise2.kr(2).range(111, 555);
var latchFreq = Hold.kr(freq, MouseX.kr(0.025, 2, 1, 0.2));
SinOsc.ar([freq, latchFreq], 0) * 0.1

// Cf. Duty
var freq = LFNoise2.ar(1).range(111, 555);
var latchFreq = Duty.ar(MouseX.kr(0.1, 1, 1, 0.2), 0, freq);
SinOsc.ar([freq, latchFreq], 0) * 0.1
