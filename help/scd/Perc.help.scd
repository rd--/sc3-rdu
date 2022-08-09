// Perc ; EnvGen of Env.perc
var t = Impulse.ar(1, 0);
SinOsc.ar(TRand.ar(200, 500, t), 0) * Perc.ar(t, 0.01, 1, 0.1, -4)

// Perc ; EnvGen of Env.perc
{
	var t = Dust.ar(1 / 4);
	SinOsc.ar(TRand.ar(200, 500, t), 0) * Perc.ar(t, 0.01, 4, 0.2, -4)
}.dup(9).splay2
