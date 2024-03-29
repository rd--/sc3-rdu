ShufflerB : PureMultiOutUGen {

	init { |... i|
		inputs = i;
		^this.initOutputs(2, rate)
	}

	// ----

	*ar { |bufnum=0 readLocationMinima=0.01 readLocationMaxima=0.02 readIncrementMinima=1 readIncrementMaxima=1 durationMinima=0.2 durationMaxima=0.2 envelopeAmplitudeMinima=0.5 envelopeAmplitudeMaxima=0.5 envelopeShapeMinima=0.5 envelopeShapeMaxima=0.5 envelopeSkewMinima=0.5 envelopeSkewMaxima=0.5 stereoLocationMinima=0.5 stereoLocationMaxima=0.5 interOffsetTimeMinima=0.05 interOffsetTimeMaxima=0.01 ftableReadLocationIncrement=1 readIncrementQuanta=0 interOffsetTimeQuanta=0 mul=1 add=0|
		^this.multiNew('audio', bufnum, readLocationMinima, readLocationMaxima, readIncrementMinima, readIncrementMaxima, durationMinima, durationMaxima, envelopeAmplitudeMinima, envelopeAmplitudeMaxima, envelopeShapeMinima, envelopeShapeMaxima, envelopeSkewMinima, envelopeSkewMaxima, stereoLocationMinima, stereoLocationMaxima, interOffsetTimeMinima, interOffsetTimeMaxima, ftableReadLocationIncrement, readIncrementQuanta, interOffsetTimeQuanta).madd(mul, add);
	}

}
