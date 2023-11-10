TrigRoundRobin : MultiOutUGen {

	*ar {
		arg numChannels = 16, in = 0;
		^this.multiNew('audio', numChannels, in)
	}

	*kr {
		arg numChannels = 16, in = 0;
		^this.multiNew('control', numChannels, in)
	}

	init {
		arg numChannels, in;
		inputs = [in];
		^this.initOutputs(numChannels, rate)
	}

}
