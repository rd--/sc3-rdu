PV_Split : PureMultiOutUGen {

	init {
		arg ... theInputs;
		inputs = theInputs;
		channels = [OutputProxy(rate, this, 0), OutputProxy(rate, this, 1)
		];
		^channels
	}

	checkInputs {
		^this.checkNInputs(2)
	}

	// ----

	*new {
		arg bufferA, bufferB;
		^this.multiNew('control', bufferA, bufferB)
	}

}
