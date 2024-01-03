// DelayMap is not a Filter because the input is not at index zero.
DelayMap : PureUGen {

	*ar { |bufnum=0 in=0 dynamic=0 spec|
		^this.multiNewList(['audio', bufnum, in, dynamic] ++ spec);
	}

}
