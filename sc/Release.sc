// c.f. Cutoff
Release : PseudoUgen {

	*ar { |in attackTime=0.02 dur=5 releaseTime=0.02|
		^in * EnvRelease.ar(attackTime, dur, releaseTime)
	}

	*new { |in attackTime=0.02 dur=5 releaseTime=0.02|
		^Release.ar(in, attackTime, dur, releaseTime)
	}

}
