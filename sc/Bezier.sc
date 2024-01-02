Bezier : PureUGen {

	*ar { |haltAfter=100 dx=0.0001 freq=440 phase=0 param|
		^this.multiNewList(['audio', haltAfter, dx, freq, phase] ++ param)
	}

	*kr { |haltAfter=100 dx=0.0001 freq=440 phase=0 param|
		^this.multiNewList(['control', haltAfter, dx, freq, phase] ++ param)
	}

}
