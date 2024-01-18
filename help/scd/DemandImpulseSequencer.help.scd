// DemandImpulseSequencer ; jmcc
var z = 0, a = 0.1, b = 0.2, c = 0.4;
var p = [
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
];
var q = Drand.dr([
	Dseq.dr([c, z, b, z, a, a, a, a, b, z, b, z, z, z, b, z], 2),
	Dseq.dr([c, z, z, z, z, z, z, z, b, z, b, z, z, z, c, z], 2),
	Dseq.dr([c, z, z, z, a, z, z, z, b, z, b, z, a, z, c, z], 2)
], inf);
var clock = Impulse.kr(9, 0);
// bass drum
var trig1 = PulseDivider.kr(clock, 16, 0);
var r = SinOsc.ar(80, 0) * Decay2.kr(trig1, 0.005, 0.5) * 0.3;
// drum
var trig2 = DemandImpulseSequencer.kr(p, clock);
var exc2 = WhiteNoise.ar * Decay2.kr(trig2, 0.005, 0.05);
var x = RingzBank.ar(exc2, { 80.rrand(800) } ! 4, nil, { 0.05.rrand(0.2) } ! 4).distort * 0.2;
// metallic
var trig3 = DemandImpulseSequencer.kr(q, clock);
var exc3 = WhiteNoise.ar * Decay2.kr(trig3, 0.005, 0.05);
var s = RingzBank.ar(exc3, { 3500.0.rrand(4000) } ! 4, nil, { 0.05.rrand(0.2) } ! 4).distort * 0.1;
// whine
var exc4 = { GrayNoise.ar } ! 2 * 0.0007;
var y = OverlapTexture({ | tr |
	var env = SinOsc.kr(TRand.kr(1, 6, tr), { TRand.kr(0, 2 * pi, tr) } ! 2) * 0.5 + 0.5;
	DynRingzBank.ar(exc4, { TIRand.kr(200, 2500, tr) }, nil, { TRand.kr(0.2, 0.8, tr) } ! 4) * env
}, 4, 2, 2).scaleneg(MouseX.kr(-1, 1, 0, 0.2));
var snd = x + (y * 0.5) + s + r;
6.do {
	snd = AllpassN.ar(LPZ2.ar(snd), 0.03, [0.03.rand, 0.03.rand], 5)
};
snd
