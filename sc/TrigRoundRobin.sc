TrigRoundRobin : MultiOutUGen {

	*ar { |numChannels = 16, in = 0 |
		^this.multiNew('audio', numChannels, in)
	}

	*kr { |numChannels = 16, in = 0 |
		^this.multiNew('control', numChannels, in)
	}

	init { |numChannels in |
		inputs = [in];
		^this.initOutputs(numChannels, rate)
	}

}
