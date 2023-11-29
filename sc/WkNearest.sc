WkNearest : MultiOutUGen {

	init {
		arg numChannels ... i;
		inputs = i;
		^this.initOutputs(numChannels, rate)
	}

	*ar {
		arg numChannels = 1, gate = 0.0, x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^this.multiNewList(['audio', numChannels, gate, x, y, z] ++ coordinateArray);
	}

	*kr {
		arg numChannels = 1, gate = 0.0, x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^this.multiNewList(['control', numChannels, gate, x, y, z] ++ coordinateArray);
	}

}

TkNearest : PseudoUgen {

	*ar {
		arg numChannels = 1, trig = 0.0, x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^WkNearest.ar(numChannels, Trig.ar(trig, SampleDur.ir()), x, y, z, coordinateArray);
	}

	*kr {
		arg numChannels = 1, trig = 0.0, x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^WkNearest.kr(numChannels, Trig.kr(trig, SampleDur.ir()), x, y, z, coordinateArray);
	}

}
