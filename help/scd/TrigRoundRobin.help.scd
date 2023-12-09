// TrigRoundRobin ; control rate
var t = Impulse.kr(1, 0);
var w = TrigRoundRobin.kr(4, t);
var e = Decay2.kr(w, 0.05, 2) * TRand.kr(0.25, 1, w);
var f = TIRand.kr(48, 84, w).midiCps;
var o = SinOsc.ar(f, 0) * e;
o.splay2

// TrigRoundRobin ; audio rate
var t = Impulse.ar(1, 0);
var w = TrigRoundRobin.ar(4, t);
var e = Decay2.ar(w, 0.05, 2) * TRand.ar(0.25, 1, w);
var f = TIRand.ar(48, 84, w).midiCps;
var o = SinOsc.ar(f, 0) * e;
o.splay2

// ---- TrigRoundRobin ; envelope array generator (for plotting)
var z = 2000;
var t = Impulse.ar(z, 0);
var w = TrigRoundRobin.ar(4, t);
Sine.ar(w, 2 / z)

// ---- TrigRoundRobin ; envelope array generator (for plotting)
var z = 5000;
var t = TDuty.ar(Dseq([5, 2, 3] / z, inf), 0, 1, 0, 0);
var w = TrigRoundRobin.ar(4, t);
var d = 5 / z; // ?
Sine.ar(w, d)

