TableRand : PureUGen {

	*kr { |trig=0.0 bufnum=0.0 mul=1.0 add=0.0|
		^this.multiNew('control', trig, bufnum).madd(mul, add)
	}

}
