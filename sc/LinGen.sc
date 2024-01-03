LinGen : PseudoUgen {

	*ar { |gate levels times|
		^CurveGen.ar(gate, levels, times, ['lin'])
	}

	*kr { |gate levels times|
		^CurveGen.kr(gate, levels, times, ['lin'])
	}

	*new { |gate levels times|
		^LinGen.ar(gate, levels, times)
	}

}
