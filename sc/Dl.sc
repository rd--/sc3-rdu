Dl : MultiOutUGen {

	init {
		arg numChannels, inputArray;
		inputs = inputArray;
		^this.initOutputs(numChannels, rate)
	}

	// ----

	*ar {
		arg numChannels = 1, inputArray = nil;
		^this.multiNewList(['audio', numChannels] ++ inputArray)
	}

}
