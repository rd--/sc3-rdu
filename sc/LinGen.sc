LinGen : PseudoUgen {

	*ar {
		arg gate, levels, times;
		^CurveGen.ar(gate, levels, times, ['lin'])
	}

	*kr {
		arg gate, levels, times;
		^CurveGen.kr(gate, levels, times, ['lin'])
	}

	*new {
		arg gate, levels, times;
		^LinGen.ar(gate, levels, times)
	}

}
