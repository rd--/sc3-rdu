Tr : PseudoUgen {

	*kr { |tr|
		^Trig.kr(tr, ControlDur.ir)
	}

	*ar { |tr|
		^Trig.ar(tr, SampleDur.ir * 2)
	}

	*new { |tr|
		^this.performList(tr.rate.rateToSelector, [tr])
	}

}
