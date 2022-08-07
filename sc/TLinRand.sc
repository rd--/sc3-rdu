TLinRand : UGen {

	*kr {
		arg lo = 0, hi = 1, minmax = 0, trigger = 0;
		^this.multiNew('control', lo, hi, minmax, trigger)
	}

}
