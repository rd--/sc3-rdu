Demultiplexer : MultiOutUGen {

	*ar { |numChannels = 16, in = 0, selector = 0|
		^this.multiNew('audio', numChannels, in, selector)
	}

	*kr { |numChannels = 16, in = 0, selector = 0|
		^this.multiNew('control', numChannels, in, selector)
	}

	init { |numChannels in selector|
		inputs = [in, selector];
		^this.initOutputs(numChannels, rate)
	}

}
