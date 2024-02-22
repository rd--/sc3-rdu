Sine : PseudoUgen {

	*ar { |trig, dur = 1 |
		^EnvGen.ar(Sine.env(trig, dur), trig)
	}

	*kr { |trig, dur = 1 |
		^EnvGen.kr(Sine.env(trig, dur), trig)
	}

	*env { |trig, dur = 1 |
		^Env.new(
			[0, 0, 1, 0],
			[0, dur / 2, dur / 2],
			'sine',
			nil,
			nil,
			0
		)
	}

}
