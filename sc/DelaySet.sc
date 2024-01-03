DelaySet : Filter {

	*ar { |in=0 spec|
		^this.multiNewList(['audio', in] ++ spec)
	}

}
