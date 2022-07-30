LinSeg {

	*envFor {
		arg coordArray;
		var coord = coordArray.clump(2).flop;
		var levels = coord.first;
		var times = coord.second;
		^Env.new([levels[0]] ++ levels, [[0]] ++ times.copyRange(0, times.size - 2), 'lin', nil, nil, 0);
	}

	*new {
		arg gate, coordArray;
		^LinSeg.ar(gate, coordArray);
	}

	*ar {
		arg gate, coordArray;
		^EnvGen.ar(LinSeg.envFor(coordArray), gate, 1, 0, 1, 0);
	}

	*kr {
		arg gate, coordArray;
		^EnvGen.kr(LinSeg.envFor(coordArray), gate, 1, 0, 1, 0);
	}

}
