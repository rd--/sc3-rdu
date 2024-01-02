Multiplexer : PureUGen {

	*kr { |selector inputArray|
		^this.multiNewList(['control', selector] ++ inputArray);
	}

	*ar { |selector inputArray|
		^this.multiNewList(['audio', selector] ++ inputArray);
	}

}
