PinkingFilterPk3 : PureUGen {

	*ar { |in|
		^this.multiNew('audio', in)
	}

	*kr { |in|
		^this.multiNew('control', in)
	}

}
