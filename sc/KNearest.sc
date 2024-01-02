KNearest : PseudoUgen {

	*ar { |numChannels=1 x=0.0 y=0.0 z=0.0 coordinateArray|
		^WkNearest.ar(numChannels, 1, x, y, z, coordinateArray);
	}

	*kr { |numChannels=1 x=0.0 y=0.0 z=0.0 coordinateArray|
		^WkNearest.kr(numChannels, 1, x, y, z, coordinateArray);
	}

}
