DurationCycle {

	*ar { | durationArray |
		^EnvGen.ar(DurationCycle.env(durationArray), 1, 1, 0, 1, 0)
	}

	*env { | durationArray |
		var sampleDuration = 1 / 48000;
		var levels = durationArray.stutter(2);
		var times = durationArray.collect { | each |
			[each - sampleDuration, sampleDuration]
		}.flat;
		^Env.circle(levels, times, 'lin')
	}

	*kr { | durationArray |
		^EnvGen.kr(DurationCycle.env(durationArray), 1, 1, 0, 1, 0)
	}

}