IRandN : MultiOutUGen {

	init {
		arg numChannels, lo, hi;
		inputs = [lo, hi];
		^this.initOutputs(numChannels, rate)
	}

	// ----

	*ir {
		arg numChannels = 2, lo = 0, hi = 127;
		^this.multiNew('scalar', numChannels, lo, hi)
	}

}
