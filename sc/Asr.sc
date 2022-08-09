Asr {

	*ar {
		arg gate = 1, attackTime = 0.01, releaseTime = 1, curves = -4;
		^EnvGen.ar(Env.asr(attackTime, 1, releaseTime, curves), gate, 1, 0, 1, 0)
	}

	*new {
		arg gate = 1, attackTime = 0.01, releaseTime = 1, curves = -4;
		^Asr.ar(gate, attackTime, releaseTime, curves)
	}

}
