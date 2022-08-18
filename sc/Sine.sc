Sine : PseudoUgen {

	*ar {
		arg trig, dur = 1;
		^ Sine.new(trig, dur)
	}

	*kr {
		arg trig, dur = 1;
		^ Sine.new(trig, dur)
	}

	*new {
		arg trig, dur = 1;
		^ Env.new(
			[0, 0, 1, 0],
			[0, dur / 2, dur / 2],
			\sine,
			nil,
			1,
			0
		).asEnvGen(trig)
	}

}
