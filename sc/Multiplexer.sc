Multiplexer : PureUGen {

	*kr {
		arg selector = 0.0, inputArray;
		^this.multiNewList(['control', selector] ++ inputArray);
	}

	*ar {
		arg selector = 0.0, inputArray;
		^this.multiNewList(['audio', selector] ++ inputArray);
	}

}
