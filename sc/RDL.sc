RDL : MultiOutUGen {
	*ar {
        arg numChannels = 1, inputArray = nil;
		^this.multiNewList(['audio', numChannels] ++ inputArray)
	}
	init {
        arg numChannels, inputArray;
		inputs = inputArray;
		^this.initOutputs(numChannels, rate)
	}
}
