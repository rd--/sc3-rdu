TDistances : PseudoUgen {

	*ar { |trig=0.0, x=0.0, y=0.0, z=0.0, coordinateArray|
		^WDistances.ar(Trig.ar(trig, SampleDur.ir()), x, y, z, coordinateArray)
	}

	*kr { |trig=0.0, x=0.0, y=0.0, z=0.0, coordinateArray|
		^WDistances.kr(Trig.kr(trig, SampleDur.ir()), x, y, z, coordinateArray)
	}

}
