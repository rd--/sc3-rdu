HoldSequence : PureUGen {

	*ar { |inArray=0.0 dur=1.0|
		var gate = DurationGate.ar(dur);
		var trig = Trig1.ar(gate, SampleDur.ir);
		var index = Stepper.ar(trig, 0, 0, inArray.size - 1, 1, 0);
		^Latch.ar(Multiplexer.ar(index, inArray), trig)
	}

	*kr { |inArray=0.0 dur=1.0|
		var gate = DurationGate.kr(dur);
		var trig = Trig1.kr(gate, ControlDur.ir);
		var index = Stepper.kr(trig, 0, 0, inArray.size - 1, 1, 0);
		^Latch.kr(Multiplexer.kr(index, inArray), trig)
	}

}
