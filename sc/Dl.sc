Dl : MultiOutUGen {

	init { |numChannels inputArray|
		inputs = inputArray;
		^this.initOutputs(numChannels, rate)
	}

	// ----

	*ar { |numChannels=1 inputArray|
		^this.multiNewList(['audio', numChannels] ++ inputArray)
	}

}
