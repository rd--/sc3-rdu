DemandSequencer : PseudoUgen {

	*ar { |inArray trig|
		^Demand.ar(trig, 0, Dseq(inArray, inf))
	}

	*kr { |inArray trig|
		^Demand.kr(trig, 0, Dseq(inArray, inf))
	}

}

+DemandSequencer {

	*new { |inArray trig|
		^DemandSequencer.ar(inArray, trig)
	}

}
