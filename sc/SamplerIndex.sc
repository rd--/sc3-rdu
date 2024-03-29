SamplerIndex : PureMultiOutUGen {

	init { |... theInputs|
		inputs = theInputs;
		channels = [OutputProxy(rate, this, 0), OutputProxy(rate, this, 1)];
		^channels
	}

	*kr { |buf=0.0 size=0.0 mnn=60.0|
		^this.multiNew('control', buf, size, mnn)
	}

}
