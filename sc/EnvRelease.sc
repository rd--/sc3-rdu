EnvRelease {

	*ar { |attackTime=0.02 dur=5 releaseTime=0.02|
		^EnvGen.ar(Env([0, 1, 1, 0], [attackTime, dur, releaseTime], 'lin', nil, nil, 0), 1, 1, 0, 1, 2)
	}

	*new { |attackTime=0.02 dur=5 releaseTime=0.02|
		^EnvRelease.ar(attackTime, dur, releaseTime)
	}

}
