DustR : UGen {
 *ar { arg iot_min = 0.1, iot_max = 1.0;
  ^this.multiNew('audio',iot_min,iot_max);
 }
}

ExpRandN : MultiOutUGen {
  *new { arg numChannels = 2, lo = 0, hi = 1;
      ^this.multiNew('scalar', numChannels, lo, hi)
  }
  init { arg numChannels, lo, hi;
      inputs = [lo, hi];
      ^this.initOutputs(numChannels, rate)
  }
}

RandN : MultiOutUGen {
  *new { arg numChannels = 2, lo = 0, hi = 1;
      ^this.multiNew('scalar', numChannels, lo, hi)
  }
  init { arg numChannels, lo, hi;
      inputs = [lo, hi];
      ^this.initOutputs(numChannels, rate)
  }
}

RBezier : UGen {
  *ar { arg haltAfter = 100, dx = 0.0001, freq = 440, phase = 0, param;
    ^this.multiNewList(['audio', freq, phase] ++ param);
  }
  *kr { arg freq = 440, phase = 0, param;
    ^this.multiNewList(['control', freq, phase] ++ param);
  }
}

RDelaySet : UGen {
  *ar { arg in = 0.0, spec;
    ^this.multiNewList(['audio', in] ++ spec);
  }
}

RDelaySetB : UGen {
 *ar { arg  bufnum = 0.0, in = 0.0, spec ;
  ^this.multiNewList(['audio', bufnum, in] ++ spec);
 }
}

RDelayMap : UGen {
 *ar { arg  bufnum = 0.0, in = 0.0, dynamic = 0.0, spec ;
  ^this.multiNewList(['audio', bufnum, in, dynamic] ++ spec);
 }
}

RDX7 : UGen {
 *ar { arg bufnum=0, on=0, off=0, data=0, vc=0, mnn=60, vel=99, pw=0, mw=0, bc=0, fc=0;
  ^this.multiNew('audio',bufnum,on,off,data,vc,mnn,vel,pw,mw,bc,fc);
 }
}

RFreezer : UGen {
 *ar { arg  bufnum = 0.0, left = 0.0, right = 1.0, gain = 1.0, increment = 1.0, incrementOffset = 0.0, incrementRandom = 0.0, rightRandom = 0.0, syncPhaseTrigger = 0.0, randomizePhaseTrigger = 0.0, numberOfLoops = 4, mul = 1.0, add = 0.0;
  ^this.multiNew('audio', bufnum, left, right, gain, increment, incrementOffset, incrementRandom, rightRandom, syncPhaseTrigger, randomizePhaseTrigger, numberOfLoops).madd(mul, add);
 }
}

RLoopSet : UGen {
 *ar { arg  bufnum = 0.0, left = 0.0, right = 1.0, gain = 1.0, increment = 1.0, spec ;
  ^this.multiNewList(['audio', bufnum, left, right, gain, increment] ++ spec);
 }
}

RObxdFilter : UGen {
  *ar { arg in=0.0, cutoff=440.0, resonance=0.0, multimode=0.5, bandpass=0.0, fourpole=0.0;
      ^this.multiNew('audio', in, cutoff, resonance, multimode, bandpass, fourpole);
  }
}

RPVDecayTbl : PV_ChainUGen {
  *new { arg fft_buf=0.0, decay_rate_buf=0.0, history_buf=0.0;
    ^this.multiNew('control', fft_buf, decay_rate_buf, history_buf);
  }
}

RShufflerB : MultiOutUGen {
 *ar { arg  bufnum = 0.0, readLocationMinima = 0.01, readLocationMaxima = 0.02, readIncrementMinima = 1.0, readIncrementMaxima = 1.0, durationMinima = 0.2, durationMaxima = 0.2, envelopeAmplitudeMinima = 0.5, envelopeAmplitudeMaxima = 0.5, envelopeShapeMinima = 0.5, envelopeShapeMaxima = 0.5, envelopeSkewMinima = 0.5, envelopeSkewMaxima = 0.5, stereoLocationMinima = 0.5, stereoLocationMaxima = 0.5, interOffsetTimeMinima = 0.05, interOffsetTimeMaxima = 0.01, ftableReadLocationIncrement = 1.0, readIncrementQuanta = 0.0, interOffsetTimeQuanta = 0.0, mul = 1.0, add = 0.0;
  ^this.multiNew('audio', bufnum, readLocationMinima, readLocationMaxima, readIncrementMinima, readIncrementMaxima, durationMinima, durationMaxima, envelopeAmplitudeMinima, envelopeAmplitudeMaxima, envelopeShapeMinima, envelopeShapeMaxima, envelopeSkewMinima, envelopeSkewMaxima, stereoLocationMinima, stereoLocationMaxima, interOffsetTimeMinima, interOffsetTimeMaxima, ftableReadLocationIncrement, readIncrementQuanta, interOffsetTimeQuanta).madd(mul, add);
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
}

RTraceRd : UGen {
 *ar { arg  bufnum = 0.0, degree = 4.0, index = 0.0, axis = 1.0, mul = 1.0, add = 0.0;
  ^this.multiNew('audio', bufnum, degree, index, axis).madd(mul, add);
 }
 *kr { arg  bufnum = 0.0, degree = 4.0, index = 0.0, axis = 1.0, mul = 1.0, add = 0.0;
  ^this.multiNew('control', bufnum, degree, index, axis).madd(mul, add);
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

TExpRandN : MultiOutUGen {
  *kr { arg numChannels = 2, lo = 0, hi = 1, trigger = 0;
      ^this.multiNew('control', numChannels, lo, hi, trigger)
  }
  init { arg numChannels, lo, hi, trigger;
      inputs = [lo, hi, trigger];
      ^this.initOutputs(numChannels, rate)
  }
}

TRandN : MultiOutUGen {
  *kr { arg numChannels = 2, lo = 0, hi = 1, trigger = 0;
      ^this.multiNew('control', numChannels, lo, hi, trigger)
  }
  init { arg numChannels, lo, hi, trigger;
      inputs = [lo, hi, trigger];
      ^this.initOutputs(numChannels, rate)
  }
}

TScramble : MultiOutUGen {
  *ir { arg trigger = 0.0, inputs;
    ^this.multiNewList(['scalar', trigger] ++ inputs);
  }
  *kr { arg trigger = 0.0, inputs;
    ^this.multiNewList(['control', trigger] ++ inputs);
  }
  init { arg ... i;
    inputs = i;
    ^this.initOutputs(i.size - 1, rate)
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
