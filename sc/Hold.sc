Hold : PureUGen {

	*ar { arg in = 0.0, dur = 1.0;
		var gate = DurationGate.ar(dur);
		var trig = Trig1.ar(gate, SampleDur.ir);
		^Latch.ar(in, trig);
	}

	*kr { arg in = 0.0, dur = 1.0;
		var gate = DurationGate.kr(dur);
		var trig = Trig1.kr(gate, ControlDur.ir);
		^Latch.kr(in, trig);
	}

	*prAr {	arg in = 0.0, dur = 1.0;
		^this.multiNew('audio', in, dur)
	}

	*prKr {
		arg in = 0.0, dur = 1.0;
		^this.multiNew('control', in, dur)
	}

}