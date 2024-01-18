PingPongDelay {

	*ar { |left right maxDelayTime delayTime feedback|
		var delaySize = maxDelayTime * SampleRate.ir;
		var phase = Phasor(0, 1, 0, delaySize, 0);
		var leftBuffer = BufAlloc(1, delaySize).clear;
		var rightBuffer = BufAlloc(1, delaySize).clear;
		var leftDelayedSignal = BufRd(1, leftBuffer, Wrap(phase - (delayTime * SampleRate.ir), 0, delaySize), 1, 2);
		var rightDelayedSignal = BufRd(1, rightBuffer, Wrap(phase - (delayTime * SampleRate.ir), 0, delaySize), 1, 2);
		var output = [leftDelayedSignal + left, rightDelayedSignal + right];
		var writer = DelayWrite([rightBuffer, leftBuffer], output * feedback);
		^output
	}

	*new { |left right maxDelayTime delayTime feedback|
		^this.ar(left, right, maxDelayTime, delayTime, feedback);
	}

}
