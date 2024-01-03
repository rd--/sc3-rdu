SvfBp : Filter {

	*ar { |in=0.0 freq=440 q=0.0 mul=1.0 add=0.0|
		^this.multiNew('audio', in, freq, q).madd(mul, add)
	}

}