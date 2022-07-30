LinGen {

	*new {
		arg gate, levels, times;
		^CurveGen(gate, levels, times, ['lin'])
	}

	*ar {
		arg gate, levels, times;
		^CurveGen.ar(gate, levels, times, ['lin'])
	}

	*kr {
		arg gate, levels, times;
		^CurveGen.kr(gate, levels, times, ['lin'])
	}

}
