DelayTap : PseudoUgen {

	*ar {
		arg bufnum = 0, delayTime = 0;
		^PlayBuf.ar(1, bufnum, 1, 1, BufDur.kr(bufnum) - delayTime * SampleRate.ir, 1, 0)
	}

	*new {
		arg bufnum = 0, delayTime = 0;
		^DelayTap.ar(bufnum, delayTime)
	}

}
