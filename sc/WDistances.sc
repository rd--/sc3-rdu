WDistances : MultiOutUGen {

	init { |...i|
		var numOutputs = ((i.size - 4) / 3).asInteger;
		inputs = i;
		^this.initOutputs(numOutputs, rate)
	}

	*ar { |gate=0.0 x=0.0 y=0.0 z=0.0 coordinateArray|
		^this.multiNewList(['audio', gate, x, y, z] ++ coordinateArray)
	}

	*kr { |gate=0.0 x=0.0 y=0.0 z=0.0 coordinateArray|
		^this.multiNewList(['control', gate, x, y, z] ++ coordinateArray)
	}

}
