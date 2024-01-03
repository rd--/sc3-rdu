Sine : PseudoUgen {

	*ar { |trig, dur = 1 |
		^Sine.new(trig, dur)
	}

	*kr { |trig, dur = 1 |
		^Sine.new(trig, dur)
	}

	*new { |trig, dur = 1 |
		var env = Env.new(
			[0, 0, 1, 0],
			[0, dur / 2, dur / 2],
			\sine,
			nil,
			nil,
			0
		);
		^env.asEnvGen(trig)
	}

}
