// c.f. Cutoff
Release : PseudoUgen {

	*ar {
		arg in, attackTime = 0.02, dur = 5, releaseTime = 0.02;
		^in * EnvRelease.ar(attackTime, dur, releaseTime)
	}

	*new {
		arg in, attackTime = 0.02, dur = 5, releaseTime = 0.02;
		^Release.ar(in, attackTime, dur, releaseTime)
	}

}
