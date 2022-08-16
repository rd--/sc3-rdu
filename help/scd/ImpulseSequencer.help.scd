// ImpulseSequencer ; jmcc
var trig = ImpulseSequencer.ar([0.2, 0.1, 0.1, 0.2, 0.1, 0.1, 0.2, 0.1], Impulse.ar(8, 0));
var amp = Decay2.ar(trig, 0.0004, 0.2);
var x = Resonz.ar({ GrayNoise.ar }.dup(2) * amp, 5200, 0.2);
4.timesRepeat({
	x = AllpassN.ar(x, 0.05, { 0.05.rand }.dup(2), 4)
});
x
