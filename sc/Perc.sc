Perc {

	*ar { |trig attackTime=0.01 releaseTime=1 curve=(-4)|
		^Env.perc(attackTime, releaseTime, 1, curve).asEnvGen(trig)
	}

	*new { |trig attackTime=0.01 releaseTime=1 curve=(-4)|
		^Perc.ar(trig, attackTime, releaseTime, curve)
	}

}
