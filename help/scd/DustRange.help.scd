// DustRange ; a = noise, b & c = impulses
var a = DustRange.ar(iotMin: 0.0001, iotMax: 0.001) * 0.1;
var b = DustRange.ar(iotMin: 0.1, iotMax: 0.1) * 0.5;
var c = DustRange.ar(iotMin: 0.5, iotMax: 1.25);
[a, b, c].splay2

// DustRange ; audio rate impulse train of varying amplitude (min = max)
[
	DustRange.ar(0.1, 0.1),
	Impulse.ar(10, 0)
] * 0.1

// DustRange ; mean iot=0.0005 is equivalent to density=2000 at dust, dustRange spacing is more uniform
[
	DustRange.ar(0.0001, 0.001) * 0.1,
	Dust.ar(2000) * 0.05
]

// DustRange ; velvet noise (approx.)
var iot = 20 / SampleRate.ir();
var x = MouseX.kr(1, 16, 1, 0.1);
var d = DustRange.ar(iot / x, iot * x);
var s = TRand.ar(-1, 1, d);
Trig.ar(d, SampleDur.ir()) * s.sign * 0.1

// DustRange ; sine sweeps
{
	var tr = DustRange.ar(0.5, 1.25);
	var dur = TRand.ar(0.01, 0.5, tr);
	var f0 = TRand.ar(48, 60, tr);
	var f1 = TRand.ar(36, 84, tr);
	var freq = TLine.ar(f0, f1, dur, tr).midiCps;
	var env = Decay2.ar(tr, 0.01, dur);
	SinOsc.ar(freq, 0) * env
} ! 2 * 0.5

//---- DustRange ; c.f. impulse
{ [Impulse.ar(freq: 1000, phase: 0) * 0.5, DustRange.ar(iotMin: 0.001, iotMax: 0.001)] }.plot(duration: 0.01)
