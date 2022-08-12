// Asr
var gate = LFPulse.ar(0.5, 0, 0.1) > 0;
SinOsc.ar(440, 0) * Asr.ar(gate, 0.05, 0.7, 0) * 0.1
