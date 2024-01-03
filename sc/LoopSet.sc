// LoopSet is not a Filter because input is not in first place.
LoopSet : PureUGen {

	*ar { |bufnum=0 left=0 right=1 gain=1 increment=1 spec|
		^this.multiNewList(['audio', bufnum, left, right, gain, increment] ++ spec)
	}

}
