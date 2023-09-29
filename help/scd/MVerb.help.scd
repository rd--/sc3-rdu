// MVerb ; static
var in = Dust.ar(density: [1, 2]);
MVerb.ar(in[0], in[1], dampingFreq: 0.1, density: 0.5, bandwidthFreq: 0.9, decay: 0.5, predelay: 0.1, size: 0.6, gain: 1, mix: 0.5, earlyMix: 0.5)

// MVerb
var freq = [1, 2.1, 2.9].collect { | item | item * 1000 };
var src = Resonz.ar(in: { Dust.ar(density: [0.25, 0.5]) } ! 3, freq: freq, bwr: 0.01).sum * 10;
var noiseIn = { | min max | LinLin.kr(in: LFNoise2.kr(freq: 1), srclo: -1, srchi: 1, dstlo: min, dsthi: max) };
var dampingFreq = 0.1;
var density = noiseIn.value(0.1, 0.9);
var bandwidthFreq = noiseIn.value(0.1, 0.9);
var decay = noiseIn.value(0.1, 0.9);
var predelay = 0.1;
var size = 0.9;
var gain = 1;
var mix = noiseIn.value(0.1, 0.9);
var earlyMix = noiseIn.value(0.1, 0.9);
MVerb.ar(src[0], src[1], dampingFreq, density, bandwidthFreq, decay, predelay, size, gain, mix, earlyMix)
