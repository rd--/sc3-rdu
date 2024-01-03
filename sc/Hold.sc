Hold : PureUGen {

	*ar { |in=0 dur=1|
		var gate = DurationGate.ar(dur);
		var trig = Trig1.ar(gate, SampleDur.ir);
		^Latch.ar(in, trig)
	}

	*kr { |in=0 dur=1|
		var gate = DurationGate.kr(dur);
		var trig = Trig1.kr(gate, ControlDur.ir);
		^Latch.kr(in, trig)
	}

	*prAr {	|in=0 dur=1|
		^this.multiNew('audio', in, dur)
	}

	*prKr { |in=0 dur=1|
		^this.multiNew('control', in, dur)
	}

}