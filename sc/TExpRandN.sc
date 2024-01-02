TExpRandN : MultiOutUGen {

	*ar { |numChannels=2 lo=0 hi=1 trigger=0|
		^this.multiNew('audio', numChannels, lo, hi, trigger)
	}

	*kr { |numChannels=2 lo=0 hi=1 trigger=0|
		^this.multiNew('control', numChannels, lo, hi, trigger)
	}

	init { |numChannels lo hi trigger|
		inputs = [lo, hi, trigger];
		^this.initOutputs(numChannels, rate)
	}

}
