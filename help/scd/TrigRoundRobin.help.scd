// TrigRoundRobin ; control rate
var t = Impulse.kr(1, 0);
var w = TrigRoundRobin.kr(numChannels: 4, in: t);
var e = Decay2.kr(w, 0.05, 2) * TRand.kr(0.25, 1, w);
var f = TIRand.kr(48, 84, w).midicps;
var o = SinOsc.ar(f, 0) * e;
Splay.ar(o)

// TrigRoundRobin ; audio rate
var t = Impulse.ar(1, 0);
var w = TrigRoundRobin.ar(4, t);
var e = Decay2.ar(w, 0.05, 2) * TRand.ar(0.25, 1, w);
var f = TIRand.ar(48, 84, w).midicps;
var o = SinOsc.ar(f, 0) * e;
Splay.ar(o)

// ---- TrigRoundRobin ; plot
var z = 2000;
var t = Impulse.ar(z, 0);
var w = TrigRoundRobin.ar(4, t);
Sine.ar(w, 2 / z)

// ---- TrigRoundRobin ; plot
var t = DurationPhasor.ar([5, 2, 3] / 10000);
var w = TrigRoundRobin.ar(4, t);
EnvTrapezoid.ar(w, Latch.ar(w, w) * 2, 0, 0.5)

// ---- TrigRoundRobin ; plot ; ?
var t = DurationPhasor.ar([5, 2, 3] / 10000);
var w = TrigRoundRobin.ar(4, t);
Sine.ar(w, Latch.ar(w, w) * 2)
