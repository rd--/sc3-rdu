Sequencer : PseudoUgen {

	*ar {
		arg valueArray, trig;
		^ Demand.ar(trig, 0, Dseq.dr(valueArray, inf))
	}

	*kr {
		arg valueArray, trig;
		^ Demand.kr(trig, 0, Dseq.dr(valueArray, inf))
	}

	*new {
		arg valueArray, trig;
		^ Sequencer.ar(valueArray, trig)
	}

}
