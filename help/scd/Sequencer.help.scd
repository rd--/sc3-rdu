// Sequencer ; jmcc
var clock = Impulse.kr(freq: 8, phase: 0);
var trig1 = ImpulseSequencer.kr(valueArray: [0.4, 0.1, 0.2, 0.1], trig: clock);
var root = Sequencer.kr(valueArray: [24, 26, 24, 22], trig: PulseDivider.kr(trig: clock, div: 64, start: 0));
var x = RLPF.ar(
	in: Decay2.kr(in: trig1, attackTime: 0.005, decayTime: 0.7) * { GrayNoise.ar() } ! 2 * 0.4,
	freq: MouseX.kr(minval: 200, maxval: 8000, warp: 1, lag: 0.2),
	rq: 0.2
).distort;
var trig2 = ImpulseSequencer.kr(valueArray: [0.4, 0.0, 0.1, 0.1, 0.4, 0.1, 0.1, 0.1], trig: clock);
var freq = (Sequencer.kr(valueArray: [33, 33, 35, 36, 45, 47, 38, 40, 33, 33, 35, 36, 47, 48, 50, 52], trig: clock) + root).midiCps;
var z = VarSaw.ar(freq: freq * [1, 1.505], iphase: 0, width: MouseY.kr(0, 1, 0, 0.2)) * Decay2.kr(in: trig2, attackTime: 0.005, decayTime: 1.4);
CombN.ar(in: x + z * 0.5, maxdelaytime: 0.26, delaytime: 0.26, decaytime: 4).softclip

// Sequencer ; jmcc
var p = Drand.dr([
	Dseq.dr([0, 0, 1, 2, 7, 8, 9, 8, 10, 10, 1, 2, 1, 2, 3, 4, 0, 0, 1, 2, 7, 8, 9, 8, 11, 11, 1, 2, 1, 2, 3, 4], 1),
	Dseq.dr([0, 0, 1, 2, 7, 8, 3, 4, 0, 0, 1, 2, 1, 2, 3, 4, 0, 0, 1, 2, 7, 8, 3, 4, 0, 0, 1, 2, 1, 2, 3, 4], 2)
], inf);
var clock = Impulse.kr(12, 0);
var root = Sequencer.kr([57, 59, 62, 55], PulseDivider.kr(clock, 128, 0));
var trig1 = ImpulseSequencer.kr([1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1], PulseDivider.kr(clock, 2, 0));
var r = LPF.ar(
	RLPF.ar(
		Decay2.kr(trig1, 0.005, 0.7) * { BrownNoise.ar } ! 2 * 3,
		MouseX.kr(200, 300, 1, 0.2),
		0.4
	).distort,
	800
);
var trig2 = ImpulseSequencer.kr([0.4, 0.1, 0.2, 0.1], clock);
var x = RLPF.ar(
	Decay2.kr(trig2, 0.005, 0.3) * { GrayNoise.ar } ! 2 * 0.4,
	MouseX.kr(200, 8000, 1, 0.2),
	0.2
).distort;
var scale = [0, 2, 3, 5, 7, 8, 10].asLocalBuf;
var trig3 = ImpulseSequencer.kr([0.4, 0.0, 0.1, 0.1, 0.4, 0.1, 0.1, 0.1] * 1.5, clock);
var freq = (DegreeToKey.kr(scale, Demand.kr(clock, 0, p), 12) - 12 + root).midiCps;
var z = RLPF.ar(
	VarSaw.ar(freq * [1, 1.505], 0, MouseY.kr(0, 1, 0, 0.2)) * Decay2.kr(trig3, 0.005, 0.8),
	MouseX.kr(200, 8000, 1, 0.2),
	0.2
).distort;
var trig4 = ImpulseSequencer.kr([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1] * 0.2, clock);
var y = SinOsc.ar((root + 24).midiCps, 0) * Decay2.kr(trig4, 0.005, 0.2);
var trig5 = ImpulseSequencer.kr([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1] * 0.3, clock);
var w = SinOsc.ar((root + 24 + 7).midiCps, 0) * Decay2.kr(trig5, 0.005, 0.2);
var snd = (r * 0.1 + x + z + [y, w]) * 0.4;
(CombN.ar(snd, 0.51, 0.51, 4) * 0.4 + snd.reverse).softclip

// Sequencer ; jmcc
var z = 0, a = 0.1, b = 0.2, c = 0.4;
var p = Dseq.dr([
	Dseq.dr([c, z, z, z, z, z, z, z], 2),
	Dseq.dr([c, z, z, b, z, z, b, z, c, z, z, z, b, z, b, a], 2),
	Drand([
		Dseq.dr([c, z, z, b, z, z, b, z, c, z, b, z, c, z, b, z], 2),
		Dseq.dr([c, z, a, b, z, a, b, z, c, z, b, z, c, a, b, a], 2),
		Dseq.dr([c, a, a, b, z, a, b, a, c, z, b, z, c, a, b, a], 2),
		Dseq.dr([c, a, a, b, z, a, b, a, c, z, b, z, z, b, a, a], 2),
		Dseq.dr([c, z, z, z, z, z, z, z], 2),
		Dseq.dr([c, z, z, b, z, z, b, z, c, z, z, z, b, z, b, a], 2)
	], inf)
]);
var q = Drand([
	Dseq.dr([c, z, b, z, a, a, a, a, b, z, b, z, z, z, b, z], 2),
	Dseq.dr([c, z, z, z, z, z, z, z, b, z, b, z, z, z, c, z], 2),
	Dseq.dr([c, z, z, z, a, z, z, z, b, z, b, z, a, z, c, z], 2)
], inf);
var clock = Impulse.kr(9, 0);
// bass drum
var trig1 = PulseDivider.kr(clock, 16, 0);
var r = SinOsc.ar(80, 0) * Decay2.kr(trig1, 0.005, 0.5) * 0.3;
// drum
var trig2 = ImpulseSequencer.kr(p, clock);
var exc2 = WhiteNoise.ar * Decay2.kr(trig2, 0.005, 0.05);
var x = RingzBank.ar(exc2, { 80.rrand(800) } ! 4, nil, { 0.05.rrand(0.2) } ! 4).distort * 0.2;
// metallic
var trig3 = ImpulseSequencer.kr(q, clock);
var exc3 = WhiteNoise.ar * Decay2.kr(trig3, 0.005, 0.05);
var s = RingzBank.ar(exc3, { 3500.0.rrand(4000) } ! 4, nil, { 0.05.rrand(0.2) } ! 4).distort * 0.1;
// whine
var exc4 = { GrayNoise.ar } ! 2 * 0.0007;
var y = OverlapTexture({ | tr |
	var env = SinOsc.kr(TRand(1, 6, tr), { TRand(0, 2 * pi, tr) } ! 2) * 0.5 + 0.5;
	DynRingzBank.ar(exc4, { TIRand(200, 2500, tr) }, nil, { TRand(0.2, 0.8, tr) } ! 4) * env
}, 4, 2, 2).scaleneg(MouseX.kr(-1, 1, 0, 0.2));
var snd = x + (y * 0.5) + s + r;
6.timesRepeat {
	snd = AllpassN.ar(LPZ2.ar(snd), 0.03, [0.03.rand, 0.03.rand], 5)
};
snd

// Sequencer ; jmcc
var clock = Impulse.kr(16, 0);
var x = SinOsc.ar(Sequencer.kr(Dwhite.dr(2000, 12000, inf), clock), 0) * Decay2.kr(clock, 0.002, 0.04);
CombN.ar(x, 0.2, { Rand(0.04, 0.2) } ! 2, 2) * Line.kr(0.2, 0, 4)

// Sequencer ; jmcc
var clock = Impulse.kr(XLine.kr(24, 1, 12), 0);
var x = SinOsc.ar(Sequencer.kr(Dwhite.dr(2000, 12000, inf), clock), 0) * Decay2.kr(clock, 0.002, 0.04);
var c = { CombN.ar(x, 0.1, { ExpRand(0.02, 0.05) } ! 2, 2) * Line.kr(0.2, 0, 12) } ! 2;
c.sum

// Sequencer ; jmcc
var p = Dseq.dr([
	Dseq.dr([24, 24, 24, 24, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 22] + 12, 3),
	Dseq.dr([24, 24, 24, 24, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 27] + 12, 1),
	Dseq.dr([29, 29, 29, 29, 27, 27, 27, 27, 29, 29, 29, 29, 30, 30, 30, 30] + 12, 3),
	Dseq.dr([29, 29, 29, 29, 27, 27, 27, 27, 29, 29, 29, 29, 30, 30, 30, 24] + 12, 1),
	Dseq.dr([24, 24, 24, 24, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 22] + 14, 3),
	Dseq.dr([24, 24, 24, 24, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 19] + 14, 1),
	Dseq.dr([24, 24, 24, 24, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 22] + 11, 3),
	Dseq.dr([24, 24, 24, 24, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 23] + 11, 1)
], inf);
var clock = Impulse.kr(12, 0);
var trig = ImpulseSequencer.kr([0.3, 0.1, 0.2, 0.1],  clock);
var env = Decay2.kr(trig, 0.005, 0.15) * 0.3;
var w;
var x = { PinkNoise.ar } ! 2 * 2 * env;
var y;
var z = LinExp.kr(LFTri.kr(0.2, 0), -1, 1, 1 / 18000, 1 / 50); // flanger lfo
var freq;
3.timesRepeat { // delays
	x = DelayL.ar(x, 0.1, z) + x
};
x = RLPF.ar(x, MouseY.kr(200, 8000, 0, 0.2), 0.2, 0.6).distort;
trig = PulseDivider.kr(clock, 2, 0);
freq = Sequencer.kr(p, trig).midiCps;
env = Decay2.kr(trig, 0.002, 2) * 0.6;
y = RLPF.ar(LFSaw.ar(freq * [1, 1.505], 0, env * 8), MouseX.kr(100, 8000, 1, 0.2) * (1 + env), 0.1).distort * 0.08;
x = CombN.ar(x + y, 0.33, 0.33, 2) * 0.5 + x;
w = x;
4.do {
	w = AllpassN.ar(w, 0.05, { Rand(0, 0.03) } ! 2, 4)
};
w
