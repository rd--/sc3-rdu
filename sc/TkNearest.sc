TkNearest : PseudoUgen {

	*ar { |numChannels=1 trig=0.0 x=0.0 y=0.0 z=0.0 coordinateArray|
		^WkNearest.ar(numChannels, Trig.ar(trig, SampleDur.ir()), x, y, z, coordinateArray);
	}

	*kr { |numChannels=1, trig=0.0 x=0.0 y=0.0 z=0.0 coordinateArray|
		^WkNearest.kr(numChannels, Trig.kr(trig, SampleDur.ir()), x, y, z, coordinateArray);
	}

}
