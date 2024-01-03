Tr1 {

	*kr { |tr|
		^Trig1.kr(tr, ControlDur.ir())
	}

	*ar { |tr|
		^Trig1.ar(tr, SampleDur.ir() * 2)
	}

	*new { |tr|
		^this.performList(tr.rate.rateToSelector, [tr])
	}

}
