DurationPulse {

	*ar { |durationArray |
		^EnvGen.ar(DurationPulse.env(durationArray), 1, 1, 0, 1, 0)
	}

	*env { |durationArray |
		var levels = durationArray.collect { |each |
			[each, each.neg]
		}.flat;
		var times = durationArray.collect { |each |
			[each / 2, each / 2]
		}.flat;
		^Env.circle(levels, times, 'hold')
	}

	*kr { |durationArray |
		^EnvGen.kr(DurationPulse.env(durationArray), 1, 1, 0, 1, 0)
	}

}

