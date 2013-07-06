RDelaySet : UGen {
 *ar { arg  in = 0.0, spec ;
  ^this.multiNewList(['audio', in] ++ spec);
 }
 *kr { arg  in = 0.0, spec ;
  ^this.multiNewList(['control', in] ++ spec);
 }
}

RDelaySetB : UGen {
 *ar { arg  bufnum = 0.0, in = 0.0, spec ;
  ^this.multiNewList(['audio', bufnum, in] ++ spec);
 }
 *kr { arg  bufnum = 0.0, in = 0.0, spec ;
  ^this.multiNewList(['control', bufnum, in] ++ spec);
 }
}

RDelayMap : UGen {
 *ar { arg  bufnum = 0.0, in = 0.0, dynamic = 0.0, spec ;
  ^this.multiNewList(['audio', bufnum, in, dynamic] ++ spec);
 }
 *kr { arg  bufnum = 0.0, in = 0.0, dynamic = 0.0, spec ;
  ^this.multiNewList(['control', bufnum, in, dynamic] ++ spec);
 }
}

RFreezer : UGen {
 *ar { arg  bufnum = 0.0, left = 0.0, right = 1.0, gain = 1.0, increment = 1.0, incrementOffset = 0.0, incrementRandom = 0.0, rightRandom = 0.0, syncPhaseTrigger = 0.0, randomizePhaseTrigger = 0.0, numberOfLoops = 4, mul = 1.0, add = 0.0;
  ^this.multiNew('audio', bufnum, left, right, gain, increment, incrementOffset, incrementRandom, rightRandom, syncPhaseTrigger, randomizePhaseTrigger, numberOfLoops).madd(mul, add);
 }
 *kr { arg  bufnum = 0.0, left = 0.0, right = 1.0, gain = 1.0, increment = 1.0, incrementOffset = 0.0, incrementRandom = 0.0, rightRandom = 0.0, syncPhaseTrigger = 0.0, randomizePhaseTrigger = 0.0, numberOfLoops = 4, mul = 1.0, add = 0.0;
  ^this.multiNew('control', bufnum, left, right, gain, increment, incrementOffset, incrementRandom, rightRandom, syncPhaseTrigger, randomizePhaseTrigger, numberOfLoops).madd(mul, add);
 }
}

RLoopSet : UGen {
 *ar { arg  bufnum = 0.0, left = 0.0, right = 1.0, gain = 1.0, increment = 1.0, spec ;
  ^this.multiNewList(['audio', bufnum, left, right, gain, increment] ++ spec);
 }
 *kr { arg  bufnum = 0.0, left = 0.0, right = 1.0, gain = 1.0, increment = 1.0, spec ;
  ^this.multiNewList(['control', bufnum, left, right, gain, increment] ++ spec);
 }
}

RShufflerB : MultiOutUGen {
 *ar { arg  bufnum = 0.0, readLocationMinima = 0.01, readLocationMaxima = 0.02, readIncrementMinima = 1.0, readIncrementMaxima = 1.0, durationMinima = 0.2, durationMaxima = 0.2, envelopeAmplitudeMinima = 0.5, envelopeAmplitudeMaxima = 0.5, envelopeShapeMinima = 0.5, envelopeShapeMaxima = 0.5, envelopeSkewMinima = 0.5, envelopeSkewMaxima = 0.5, stereoLocationMinima = 0.5, stereoLocationMaxima = 0.5, interOffsetTimeMinima = 0.05, interOffsetTimeMaxima = 0.01, ftableReadLocationIncrement = 1.0, readIncrementQuanta = 0.0, interOffsetTimeQuanta = 0.0, mul = 1.0, add = 0.0;
  ^this.multiNew('audio', bufnum, readLocationMinima, readLocationMaxima, readIncrementMinima, readIncrementMaxima, durationMinima, durationMaxima, envelopeAmplitudeMinima, envelopeAmplitudeMaxima, envelopeShapeMinima, envelopeShapeMaxima, envelopeSkewMinima, envelopeSkewMaxima, stereoLocationMinima, stereoLocationMaxima, interOffsetTimeMinima, interOffsetTimeMaxima, ftableReadLocationIncrement, readIncrementQuanta, interOffsetTimeQuanta).madd(mul, add);
 }
 *kr { arg  bufnum = 0.0, readLocationMinima = 0.01, readLocationMaxima = 0.02, readIncrementMinima = 1.0, readIncrementMaxima = 1.0, durationMinima = 0.2, durationMaxima = 0.2, envelopeAmplitudeMinima = 0.5, envelopeAmplitudeMaxima = 0.5, envelopeShapeMinima = 0.5, envelopeShapeMaxima = 0.5, envelopeSkewMinima = 0.5, envelopeSkewMaxima = 0.5, stereoLocationMinima = 0.5, stereoLocationMaxima = 0.5, interOffsetTimeMinima = 0.05, interOffsetTimeMaxima = 0.01, ftableReadLocationIncrement = 1.0, readIncrementQuanta = 0.0, interOffsetTimeQuanta = 0.0, mul = 1.0, add = 0.0;
  ^this.multiNew('control', bufnum, readLocationMinima, readLocationMaxima, readIncrementMinima, readIncrementMaxima, durationMinima, durationMaxima, envelopeAmplitudeMinima, envelopeAmplitudeMaxima, envelopeShapeMinima, envelopeShapeMaxima, envelopeSkewMinima, envelopeSkewMaxima, stereoLocationMinima, stereoLocationMaxima, interOffsetTimeMinima, interOffsetTimeMaxima, ftableReadLocationIncrement, readIncrementQuanta, interOffsetTimeQuanta).madd(mul, add);
 }
 init {arg ... i;
  inputs = i;
  ^this.initOutputs(2,rate);
 }
}

RShufflerL : UGen {
 *ar { arg  in = 0.0, fragmentSize = 0.01, maxDelay = 0.01, mul = 1.0, add = 0.0;
  ^this.multiNew('audio', in, fragmentSize, maxDelay).madd(mul, add);
 }
 *kr { arg  in = 0.0, fragmentSize = 0.01, maxDelay = 0.01, mul = 1.0, add = 0.0;
  ^this.multiNew('control', in, fragmentSize, maxDelay).madd(mul, add);
 }
}

RTraceRd : UGen {
 *ar { arg  bufnum = 0.0, degree = 4.0, index = 0.0, axis = 1.0, mul = 1.0, add = 0.0;
  ^this.multiNew('audio', bufnum, degree, index, axis).madd(mul, add);
 }
 *kr { arg  bufnum = 0.0, degree = 4.0, index = 0.0, axis = 1.0, mul = 1.0, add = 0.0;
  ^this.multiNew('control', bufnum, degree, index, axis).madd(mul, add);
 }
}

RTraceRdX : UGen {
 *kr { arg bufnum = 0.0, degree = 4.0, index = 0.0, mul = 1.0, add = 0.0;
  ^RTraceRd.kr(bufnum, degree, index, 1.0, mul, add);
 }
}

RTraceRdY : UGen {
 *kr { arg bufnum = 0.0, degree = 4.0, index = 0.0, mul = 1.0, add = 0.0;
  ^RTraceRd.kr(bufnum, degree, index, 2.0, mul, add);
 }
}

RTraceRdZ : UGen {
 *kr { arg bufnum = 0.0, degree = 4.0, index = 0.0, mul = 1.0, add = 0.0;
  ^RTraceRd.kr(bufnum, degree, index, 3.0, mul, add);
 }
}

RPlayTrace : UGen {
 *ar { arg  bufnum = 0.0, degree = 4.0, rate = 0.0, axis = 1.0, mul = 1.0, add = 0.0;
  ^this.multiNew('audio', bufnum, degree, rate, axis).madd(mul, add);
 }
 *kr { arg  bufnum = 0.0, degree = 4.0, rate = 0.0, axis = 1.0, mul = 1.0, add = 0.0;
  ^this.multiNew('control', bufnum, degree, rate, axis).madd(mul, add);
 }
}

PV_Split : MultiOutUGen {
	*new { arg bufferA, bufferB;
		^this.multiNew('control', bufferA, bufferB)
	}
	init { arg ... theInputs;
		inputs = theInputs;
		channels = [
			OutputProxy(rate, this, 0),
			OutputProxy(rate, this, 1)
		];
		^channels
	}
	checkInputs { ^this.checkNInputs(2) }
}

// Local Variables:
// truncate-lines:t
// End:
