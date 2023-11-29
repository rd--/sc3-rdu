WDistances : MultiOutUGen {

	init {
		arg ...i;
		var numOutputs = ((i.size - 4) / 3).asInteger;
		inputs = i;
		^this.initOutputs(numOutputs, rate)
	}

	*ar {
		arg gate = 0.0, x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^this.multiNewList(['audio', gate, x, y, z] ++ coordinateArray);
	}

	*kr {
		arg gate = 0.0, x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^this.multiNewList(['control', gate, x, y, z] ++ coordinateArray);
	}

}

TDistances : PseudoUgen {

	*ar {
		arg trig = 0.0, x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^WDistances.ar(Trig.ar(trig, SampleDur.ir()), x, y, z, coordinateArray);
	}

	*kr {
		arg trig = 0.0, x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^WDistances.kr(Trig.kr(trig, SampleDur.ir()), x, y, z, coordinateArray);
	}

}

Distances : PseudoUgen {

	*ar {
		arg x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^WDistances.ar(1, x, y, z, coordinateArray);
	}

	*kr {
		arg x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^WDistances.kr(1, x, y, z, coordinateArray);
	}

}
