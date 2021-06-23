PV_Split : MultiOutUGen {
	*new { arg bufferA, bufferB;
		^this.multiNew('control', bufferA, bufferB)
	}
	init { arg ... theInputs;
		inputs = theInputs;
		channels = [
			OutputProxy(rate, this, 0),
			OutputProxy(rate, this, 1)
		];
		^channels
	}
	checkInputs { ^this.checkNInputs(2) }
}
