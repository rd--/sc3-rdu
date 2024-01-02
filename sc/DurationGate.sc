DurationGate : PureUGen {

	*ar { |dur=1.0|
		^this.multiNew('audio', dur)
	}

	*kr { |dur=1.0|
		^this.multiNew('control', dur)
	}

}
