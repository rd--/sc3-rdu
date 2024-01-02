DemandImpulseSequencer : PseudoUgen {

	*ar { |inArray trig|
		^DemandSequencer.ar(inArray, trig) * trig
	}

	*kr { |inArray trig|
		^DemandSequencer.kr(inArray, trig) * trig
	}

}
