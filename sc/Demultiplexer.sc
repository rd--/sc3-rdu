Demultiplexer : MultiOutUGen {

	*ar {
		arg numChannels = 16, in = 0, selector = 0;
		^this.multiNew('audio', numChannels, in, selector)
	}

	*kr {
		arg numChannels = 16, in = 0, selector = 0;
		^this.multiNew('control', numChannels, in, selector)
	}

	init {
		arg numChannels, in, selector;
		inputs = [in, selector];
		^this.initOutputs(numChannels, rate)
	}

}
