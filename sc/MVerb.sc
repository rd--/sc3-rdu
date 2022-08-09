MVerb : MultiOutUGen {

	init { arg ... theInputs;
		inputs = theInputs;
		channels = [
			OutputProxy(rate, this, 0),
			OutputProxy(rate, this, 1)
		];
		^channels
	}

	// ----

	*ar {
		arg in1, in2, dampingFreq = 0.1, density = 0.5, bandwidthFreq = 0.9, decay = 0.5, predelay = 0.1, size = 1, gain = 1, mix = 1, earlyMix = 1;
		^this.multiNew('audio', in1, in2, dampingFreq, density, bandwidthFreq, decay, predelay, size, gain, mix, earlyMix);
	}

}

