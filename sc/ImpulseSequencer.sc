ImpulseSequencer : PseudoUgen {

	*ar {
		arg valueArray, trig;
		^ Sequencer.ar(valueArray, trig) * trig
	}

	*kr {
		arg valueArray, trig;
		^ Sequencer.kr(valueArray, trig) * trig
	}

	*new {
		arg valueArray, trig;
		^ Sequencer.new(valueArray, trig) * trig
	}

}
