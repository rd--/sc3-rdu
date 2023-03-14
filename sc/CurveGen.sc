CurveGen : PseudoUgen {

	*envFor {
		arg levels, times, curves;
		^Env(
			[levels.first] ++ levels,
			[0] ++ times,
			[0] ++ curves.extendCyclically(times.size),
			nil,
			nil,
			0
		)
	}

	*new {
		arg gate, levels, times, curves;
		^this.ar(gate, levels, times, curves)
	}

	*ar {
		arg gate, levels, times, curves;
		^EnvGen.ar(this.envFor(levels, times, curves), gate, 1, 0, 1, 0)
	}

	*kr {
		arg gate, levels, times, curves;
		^EnvGen.kr(this.envFor(levels, times, curves), gate, 1, 0, 1, 0)
	}

}
