DurationGate : PureUGen {

	*ar {
		arg dur = 1.0;
		^this.multiNew('audio', dur)
	}

	*kr {
		arg dur = 1.0;
		^this.multiNew('control', dur)
	}

}
