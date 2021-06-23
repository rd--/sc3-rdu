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

RLoopSet : UGen {
 *ar { arg  bufnum = 0.0, left = 0.0, right = 1.0, gain = 1.0, increment = 1.0, spec ;
  ^this.multiNewList(['audio', bufnum, left, right, gain, increment] ++ spec);
 }
}

RShufflerL : UGen {
 *ar { arg  in = 0.0, fragmentSize = 0.01, maxDelay = 0.01, mul = 1.0, add = 0.0;
  ^this.multiNew('audio', in, fragmentSize, maxDelay).madd(mul, add);
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
