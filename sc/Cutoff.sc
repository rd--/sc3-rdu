// c.f. Release
Cutoff {

	*new {
		arg sustainTime = 0.01, releaseTime = 1, curve = -4;
		^EnvGen.ar(Env.new([1, 1, 0], [sustainTime, releaseTime], curve, nil, nil, 0), 1, 1, 0, 1, 0)
	}

}
