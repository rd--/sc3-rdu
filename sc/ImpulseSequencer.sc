ImpulseSequencer : PseudoUgen {

	*ar { |inArray trig|
		^Sequencer.ar(inArray, trig) * trig
	}

	*kr { |inArray trig|
		^Sequencer.kr(inArray, trig) * trig
	}

}

+ImpulseSequencer {

	*new { |inArray trig|
		^ImpulseSequencer.ar(inArray, trig)
	}

}
