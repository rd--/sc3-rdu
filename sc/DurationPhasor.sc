DurationPhasor {

	*ar { | durationArray |
		^EnvGen.ar(DurationPhasor.env(durationArray), 1, 1, 0, 1, 0)
	}

	*env { | durationArray |
		var levels = durationArray.collect { | each |
			[each, each.neg]
		}.flat;
		var times = durationArray.collect { | each |
			[each, 0]
		}.flat;
		^Env.circle(levels, times, 'lin')
	}

	*kr { | durationArray |
		^EnvGen.kr(DurationPhasor.env(durationArray), 1, 1, 0, 1, 0)
	}

}

