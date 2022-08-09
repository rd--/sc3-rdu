Perc {

	*ar {
		arg trig, attackTime = 0.01, releaseTime = 1, level = 1, curve = -4;
		^Env.perc(attackTime, releaseTime, level, curve).asEnvGen(trig)
	}

	*new {
		arg trig, attackTime = 0.01, releaseTime = 1, level = 1, curve = -4;
		^Perc.ar(trig, attackTime, releaseTime, level, curve)
	}

}
