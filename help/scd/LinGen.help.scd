// LinGen
var voiceFunc = { | e |
	var freq = LinGen.kr(e.w, e.p.unitCps * [2, 1, 0.5], [0.25, 1]);
	SinOsc.ar(freq, 0) * e.z * e.w
};
Voicer(16, voiceFunc).sum
