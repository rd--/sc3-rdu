IRandN : MultiOutUGen {

	init { |numChannels lo hi|
		inputs = [lo, hi];
		^this.initOutputs(numChannels, rate)
	}

	// ----

	*ir { |numChannels=2 lo=0 hi=127|
		^this.multiNew('scalar', numChannels, lo, hi)
	}

}
