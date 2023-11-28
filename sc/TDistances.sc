TDistances : MultiOutUGen {

	init {
		arg ...i;
		var numOutputs = ((i.size - 4) / 3).asInteger;
		inputs = i;
		^this.initOutputs(numOutputs, rate)
	}

	*ar {
		arg trig = 0.0, x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^this.multiNewList(['audio', trig, x, y, z] ++ coordinateArray);
	}

	*kr {
		arg trig = 0.0, x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^this.multiNewList(['control', trig, x, y, z] ++ coordinateArray);
	}

}
