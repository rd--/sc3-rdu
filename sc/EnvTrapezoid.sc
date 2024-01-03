EnvTrapezoid : PureUGen {

	*ar { |trig=0 dur=1 shape=0 skew=0.5|
		^this.multiNew('audio', trig, dur, shape, skew)
	}

	*kr { |trig=0 dur=1 shape=0 skew=0.5|
		^this.multiNew('control', trig, dur, shape, skew)
	}

}