// CurveGen
var voiceFunc = {
	arg e;
	var freq = CurveGen.kr(e.w, e.p.unitCps * [2, 1, 0.5], [0.5, 1], [-4, 4]);
	var amp = CurveGen.kr(e.w, 0.1 * [0, 1, 0.5, 0], [0.01, 0.5, 1], [-4, 4]);
	SinOsc.ar(freq, 0) * amp
};
Voicer(16, voiceFunc).sum
