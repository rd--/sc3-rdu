TkNearest : MultiOutUGen {

	init {
		arg numChannels ... i;
		inputs = i;
		^this.initOutputs(numChannels, rate)
	}

	*ar {
		arg numChannels = 1, trig = 0.0, x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^this.multiNewList(['audio', numChannels, trig, x, y, z] ++ coordinateArray);
	}

	*kr {
		arg numChannels = 1, trig = 0.0, x = 0.0, y = 0.0, z = 0.0, coordinateArray;
		^this.multiNewList(['control', numChannels, trig, x, y, z] ++ coordinateArray);
	}

}
