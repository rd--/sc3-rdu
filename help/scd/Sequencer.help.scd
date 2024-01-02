// Sequencer ; Jmcc
var clock = Impulse.kr(
	freq: 8,
	phase: 0
);
var trig1 = ImpulseSequencer.kr(
	inArray: [0.4, 0.1, 0.2, 0.1],
	trig: clock
);
var root = Sequencer.kr(
	inArray: [24, 26, 24, 22],
	trig: PulseDivider.kr(trig: clock, div: 64, start: 0)
);
var x = RLPF.ar(
	in: Decay2.kr(
		in: trig1,
		attackTime: 0.005,
		decayTime: 0.7
	) * { GrayNoise.ar() } ! 2 * 0.4,
	freq: MouseX.kr(
		minval: 200,
		maxval: 8000,
		warp: 1,
		lag: 0.2
	),
	rq: 0.2
).distort;
var trig2 = ImpulseSequencer.kr(
	inArray: [0.4, 0.0, 0.1, 0.1, 0.4, 0.1, 0.1, 0.1],
	trig: clock
);
var freq = (Sequencer.kr(
	inArray: [33, 33, 35, 36, 45, 47, 38, 40, 33, 33, 35, 36, 47, 48, 50, 52],
	trig: clock
) + root).midiCps;
var z = VarSaw.ar(
	freq: freq * [1, 1.505],
	iphase: 0,
	width: MouseY.kr(0, 1, 0, 0.2)
) * Decay2.kr(
	in: trig2,
	attackTime: 0.005,
	decayTime: 1.4
);
CombN.ar(
	in: x + z * 0.5,
	maxdelaytime: 0.26,
	delaytime: 0.26,
	decaytime: 4
).softclip

// Sequencer ; jmcc
var rp = { |x n| (x ! n).flatten };
var p = [
	rp.([24, 24, 24, 24, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 22] + 12, 3),
	rp.([24, 24, 24, 24, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 27] + 12, 1),
	rp.([29, 29, 29, 29, 27, 27, 27, 27, 29, 29, 29, 29, 30, 30, 30, 30] + 12, 3),
	rp.([29, 29, 29, 29, 27, 27, 27, 27, 29, 29, 29, 29, 30, 30, 30, 24] + 12, 1),
	rp.([24, 24, 24, 24, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 22] + 14, 3),
	rp.([24, 24, 24, 24, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 19] + 14, 1),
	rp.([24, 24, 24, 24, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 22] + 11, 3),
	rp.([24, 24, 24, 24, 26, 26, 26, 26, 27, 27, 27, 27, 26, 26, 26, 23] + 11, 1)
].flatten;
var clock = Impulse.kr(12, 0);
var trig = ImpulseSequencer.kr([0.3, 0.1, 0.2, 0.1], clock);
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
