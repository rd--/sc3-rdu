/* EnvTrapezoid ; default parameters */
var tr = Impulse.ar(1, 0);
var env = EnvTrapezoid.ar(tr, 0.5, 0, 0.5);
SinOsc.ar(440, 0) * env * 0.1

/* EnvTrapezoid ; randomised parameters */
var tr = Impulse.ar(2, 0);
var env = EnvTrapezoid.ar(
	tr,
	TRand.ar(0.05, 0.25, tr),
	TRand.ar(0.25, 0.75, tr),
	TRand.ar(0.1, 0.9, tr)
);
SinOsc.ar(440, 0) * env * 0.1
