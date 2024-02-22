Perc {

	*ar { |trig attackTime=0.01 releaseTime=1 curve=(-4)|
		^EnvGen.ar(Env.perc(attackTime, releaseTime, 1, curve), trig)
	}

	*new { |trig attackTime=0.01 releaseTime=1 curve=(-4)|
		^Perc.ar(trig, attackTime, releaseTime, curve)
	}

}
