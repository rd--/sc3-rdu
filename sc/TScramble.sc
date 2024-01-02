TScramble : MultiOutUGen {

	*ar { |trigger=0.0 inputs|
		^this.multiNewList(['audio', trigger] ++ inputs)
	}

	*ir { |trigger=0.0 inputs|
		^this.multiNewList(['scalar', trigger] ++ inputs)
	}

	*kr { |trigger=0.0 inputs|
		^this.multiNewList(['control', trigger] ++ inputs)
	}

	init { |... i|
		inputs = i;
		^this.initOutputs(i.size - 1, rate)
	}

}
