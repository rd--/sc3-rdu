/* EnvTrapezoid ; audio rate ; default parameters ; keywords */
var tr = Impulse.ar(freq: 1, phase: 0);
var env = EnvTrapezoid.ar(trig: tr, dur: 0.5, shape: 0, skew: 0.5);
SinOsc.ar(freq: 440, phase: 0) * env * 0.1

/* EnvTrapezoid ; control rate ; default parameters */
var tr = Impulse.kr(1, 0);
var env = EnvTrapezoid.kr(tr, 0.5, 0, 0.5);
SinOsc.ar(440, 0) * env * 0.1

/* EnvTrapezoid ; audio rate ; randomised parameters */
var tr = Impulse.ar(4, 0);
var env = EnvTrapezoid.ar(
	tr,
	TRand.ar(0.02, 0.20, tr),
	TRand.ar(0.25, 0.75, tr),
	TRand.ar(0.1, 0.9, tr)
);
SinOsc.ar(440, 0) * env * 0.1

/* EnvTrapezoid ; control rate ; randomised parameters */
var tr = Impulse.kr(4, 0);
var env = EnvTrapezoid.kr(
	tr,
	TRand.kr(0.02, 0.20, tr),
	TRand.kr(0.25, 0.75, tr),
	TRand.kr(0.1, 0.9, tr)
);
SinOsc.ar(440, 0) * env * 0.1
