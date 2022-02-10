// DustRange ; a = noise, b = impulses
var a = DustRange.ar(iotMin: 0.0001, iotMax: 0.001) * 0.1;
var b = DustRange.ar(iotMin: 0.1, iotMax: 0.1) * 0.5;
[a, b]

// DustRange ; audio rate impulse train of varying amplitude (min = max)
[DustRange.ar(0.1, 0.1), Impulse.ar(10, 0)] * 0.1

// DustRange ; mean iot=0.0005 is equivalent to density=2000 at dust, dustRange spacing is more uniform
[DustRange.ar(0.0001, 0.001) * 0.1, Dust.ar(2000) * 0.05]

// DustRange ; velvet noise (approx.)
var iot = 20 / SampleRate.ir();
var x = MouseX.kr(1, 16, 1, 0.1);
var d = DustRange.ar(iot / x, iot * x);
var s = TRand.ar(-1, 1, d);
Trig.ar(d, SampleDur.ir()) * s.sign * 0.1

//---- DustRange ; c.f. impulse
{ [Impulse.ar(freq: 1000, phase: 0) * 0.5, DustRange.ar(iotMin: 0.001, iotMax: 0.001)] }.plot(duration: 0.01)
