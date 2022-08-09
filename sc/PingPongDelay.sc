PingPongDelay {

	*ar {
		arg left, right, maxDelayTime, delayTime, feedback;
		var delaySize = maxDelayTime * SampleRate.ir;
		var phase = Phasor(0, 1, 0, delaySize, 0);
		var leftBuffer  = BufAlloc(1, delaySize).clearBuf; // allocate a buffer for the left delay line
		var rightBuffer  = BufAlloc(1, delaySize).clearBuf; // allocate a buffer for the right delay line
		var leftDelayedSignal = BufRd(1, leftBuffer, Wrap(phase - (delayTime * SampleRate.ir), 0, delaySize), 1, 2); // tap the left delay line
		var rightDelayedSignal = BufRd(1, rightBuffer, Wrap(phase - (delayTime * SampleRate.ir), 0, delaySize), 1, 2); // tap the left delay line
		var output = [leftDelayedSignal + left, rightDelayedSignal + right]; // mix the delayed signal with the input
		var writer = DelayWrite([rightBuffer, leftBuffer], output * feedback); // feedback to buffers in reverse order
		^output.mrg(writer)  // output the mixed signal and force the DelayWr into the call graph
	}

	*new {
		arg left, right, maxDelayTime, delayTime, feedback;
		^this.ar(left, right, maxDelayTime, delayTime, feedback);
	}

}
