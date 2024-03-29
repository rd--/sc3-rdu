// TrigAllocator ; no voice stealing
var t = Impulse.kr(1, 0);
var d = TIRand.kr(2, 9, t);
var w = TrigAllocator.kr(numChannels: 8, algorithm: 0, in: t, dur: d);
var e = Asr.ar(w, d / 3, d / 3, -4) * TRand.kr(0.1, 0.2, w);
var f = TIRand.kr(48, 72, w).midicps + TRand.kr(-9, 9, w);
var o = SinOsc.ar(f, 0) * e;
Splay.ar(o)

// TrigAllocator ; voice stealing ; algorithm input selects rule
var t = Impulse.kr(4, 0);
var d = TRand.kr(0.2, 2, t);
var w = TrigAllocator.kr(5, 1, t, d);
var e = Asr.ar(w, 0.01, d / 2, -4) * TRand.kr(0.1, 0.2, w);
var f = TIRand.kr(48, 72, w).midicps + TRand.kr(-9, 9, w);
var o = SinOsc.ar(f, 0) * e;
Splay.ar(o)

// TrigAllocator ; cycle when not stealing
var t = Impulse.kr(4, 0);
var w = TrigAllocator.kr(16, 0, t, 0.001);
var e = Decay2.kr(w, 0.01, 4);
var f = TIRand.kr(84, 96, w).midicps + TRand.kr(-9, 9, w);
var o = SinOsc.ar(f, 0) * e * 0.1;
Splay.ar(o)

// ---- TrigAllocator ; envelope array generator (for plotting) ; audio-rate with i/k-rate dur
var d = 1 / 1000;
var t = Impulse.ar(1 / d, 0);
var w = TrigAllocator.ar(4, 0, t, SampleDur.ir());
Sine.ar(w, d * 2)
