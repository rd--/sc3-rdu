TLinRandN : MultiOutUGen {

	*ar { |numChannels=2 lo=0 hi=1 minMax=0 trigger=0|
		^this.multiNew('audio', numChannels, lo, hi, minMax, trigger)
	}

	*kr { |numChannels=2 lo=0 hi=1 minMax=0 trigger=0|
		^this.multiNew('control', numChannels, lo, hi, minMax, trigger)
	}

	init { |numChannels lo hi minMax trigger|
		inputs = [lo, hi, minMax, trigger];
		^this.initOutputs(numChannels, rate)
	}

}
