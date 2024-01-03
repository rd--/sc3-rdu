// DelaySetBuf is not a Filter because input is not at first index
DelaySetBuf : PureUGen {

	*ar { |bufnum=0.0 in=0.0 spec|
		^this.multiNewList(['audio', bufnum, in] ++ spec)
	}

}
