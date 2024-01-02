Sequencer : PseudoUgen {

	*ar { |inArray trig|
		var index = Stepper.ar(trig, 0, 0, inArray.size - 1, 1, 0);
		^Select.ar(index, inArray)
	}

	*kr { |inArray trig|
		var index = Stepper.kr(trig, 0, 0, inArray.size - 1, 1, 0);
		^Select.kr(index, inArray)
	}

}
