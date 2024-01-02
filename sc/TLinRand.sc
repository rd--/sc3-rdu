TLinRand : UGen {

	*ar { |lo=0 hi=1 minMax=0 trigger=0|
		^this.multiNew('audio', lo, hi, minMax, trigger)
	}

	*kr { |lo=0 hi=1 minMax=0 trigger=0|
		^this.multiNew('control', lo, hi, minMax, trigger)
	}

}
