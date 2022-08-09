DelayMap : PureUGen { // not Filter because input is not at argument zero

	*ar {
		arg bufnum = 0.0, in = 0.0, dynamic = 0.0, spec;
		^this.multiNewList(['audio', bufnum, in, dynamic] ++ spec);
	}

}
