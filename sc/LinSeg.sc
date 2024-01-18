LinSeg : PseudoUgen {

	*ar { |gate coordArray|
		^EnvGen.ar(LinSeg.envFor(coordArray), gate, 1, 0, 1, 0)
	}

	*envFor { |coordArray|
		var coord = coordArray.clump(2).flop;
		var levels = coord[0];
		var times = coord[1];
		^Env.new([levels[0]] ++ levels, [[0]] ++ times.copyRange(0, times.size - 2), 'lin', nil, nil, 0)
	}

	*kr { |gate coordArray|
		^EnvGen.kr(LinSeg.envFor(coordArray), gate, 1, 0, 1, 0)
	}

	*new { |gate coordArray|
		^LinSeg.ar(gate, coordArray)
	}

}
