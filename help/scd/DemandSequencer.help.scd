// DemandSequencer ; jmcc
var p = Drand([
	Dseq([0, 0, 1, 2, 7, 8, 9, 8, 10, 10, 1, 2, 1, 2, 3, 4, 0, 0, 1, 2, 7, 8, 9, 8, 11, 11, 1, 2, 1, 2, 3, 4], 1),
	Dseq([0, 0, 1, 2, 7, 8, 3, 4, 0, 0, 1, 2, 1, 2, 3, 4, 0, 0, 1, 2, 7, 8, 3, 4, 0, 0, 1, 2, 1, 2, 3, 4], 2)
], inf);
var clock = Impulse.kr(12, 0);
var root = Sequencer.kr(
	[57, 59, 62, 55],
	PulseDivider.kr(clock, 128, 0)
);
var trig1 = ImpulseSequencer.kr(
	[1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1],
	PulseDivider.kr(clock, 2, 0)
);
var r = LPF.ar(
	RLPF.ar(
		Decay2.kr(trig1, 0.005, 0.7) * { BrownNoise.ar } ! 2 * 3,
		MouseX.kr(200, 300, 1, 0.2),
		0.4
	).distort,
	800
);
var trig2 = ImpulseSequencer.kr(
	[0.4, 0.1, 0.2, 0.1],
	clock
);
var x = RLPF.ar(
	Decay2.kr(trig2, 0.005, 0.3) * { GrayNoise.ar } ! 2 * 0.4,
	MouseX.kr(200, 8000, 1, 0.2),
	0.2
).distort;
var scale = [0, 2, 3, 5, 7, 8, 10].asLocalBuf;
var trig3 = ImpulseSequencer.kr(
	[0.4, 0.0, 0.1, 0.1, 0.4, 0.1, 0.1, 0.1] * 1.5,
	clock
);
var freq = (DegreeToKey.kr(scale, DemandSequencer.kr(p, clock), 12) - 12 + root).midicps;
var z = RLPF.ar(
	VarSaw.ar(freq * [1, 1.505], 0, MouseY.kr(0, 1, 0, 0.2)) * Decay2.kr(trig3, 0.005, 0.8),
	MouseX.kr(200, 8000, 1, 0.2),
	0.2
).distort;
var trig4 = ImpulseSequencer.kr(
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1] * 0.2,
	clock
);
var y = SinOsc.ar((root + 24).midicps, 0) * Decay2.kr(trig4, 0.005, 0.2);
var trig5 = ImpulseSequencer.kr(
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1] * 0.3,
	clock
);
var w = SinOsc.ar((root + 24 + 7).midicps, 0) * Decay2.kr(trig5, 0.005, 0.2);
var snd = (r * 0.1 + x + z + [y, w]) * 0.4;
(CombN.ar(snd, 0.51, 0.51, 4) * 0.4 + snd.reverse).softclip

// DemandSequencer ; Jmcc ; cf. TRand
var clock = Impulse.kr(16, 0);
var x = SinOsc.ar(DemandSequencer.kr(Dwhite(2000, 12000, inf), clock), 0) * Decay2.kr(clock, 0.002, 0.04);
CombN.ar(x, 0.2, { Rand(0.04, 0.2) } ! 2, 2) * Line.kr(0.2, 0, 4)

// DemandSequencer ; Jmcc ; cf. TRand
var clock = Impulse.kr(XLine.kr(24, 1, 12), 0);
var x = SinOsc.ar(DemandSequencer.kr(Dwhite(2000, 12000, inf), clock), 0) * Decay2.kr(clock, 0.002, 0.04);
var c = { CombN.ar(x, 0.1, { ExpRand(0.02, 0.05) } ! 2, 2) * Line.kr(0.2, 0, 12) } ! 2;
c.sum
