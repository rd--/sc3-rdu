TracePlay : PureUGen {

	*ar { |bufnum=0 degree=4 rate=0 axis=1 mul=1 add=0|
		^this.multiNew('audio', bufnum, degree, rate, axis).madd(mul, add)
	}

	*kr { |bufnum=0 degree=4 rate=0 axis=1 mul=1 add=0|
		^this.multiNew('control', bufnum, degree, rate, axis).madd(mul, add);
	}

}
