EnvTrapezoid : PureUGen {

	*ar {
		arg trig = 0.0, dur = 1.0, shape = 0.0, skew = 0.5;
		^this.multiNew('audio', trig, dur, shape, skew)
	}

	*kr {
		arg trig = 0.0, dur = 1.0, shape = 0.0, skew = 0.5;
		^this.multiNew('control', trig, dur, shape, skew)
	}

}