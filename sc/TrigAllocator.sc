TrigAllocator : MultiOutUGen {

	*ar { |numChannels = 16, algorithm = 0, in = 0, dur = 0.1 |
		^this.multiNew('audio', numChannels, algorithm, in, dur)
	}

	*kr { |numChannels = 16, algorithm = 0, in = 0, dur = 0.1 |
		^this.multiNew('control', numChannels, algorithm, in, dur)
	}

	init { |numChannels algorithm in dur |
		inputs = [algorithm, in, dur];
		^this.initOutputs(numChannels, rate)
	}

}
