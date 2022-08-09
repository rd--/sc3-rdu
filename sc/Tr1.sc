Tr1 {

	*kr {
		arg tr; ^Trig1.kr(tr, ControlDur.ir())
	}

	*ar {
		arg tr; ^Trig1.ar(tr, SampleDur.ir() * 2)
	}

	*new {
		arg tr; ^this.performList(tr.rate.rateToSelector, [tr])
	}

}
