WkNearest : MultiOutUGen {

	init { |numChannels ... i|
		inputs = i;
		^this.initOutputs(numChannels, rate)
	}

	*ar { |numChannels=1 gate=0.0 x=0.0 y=0.0 z=0.0 coordinateArray|
		^this.multiNewList(['audio', numChannels, gate, x, y, z] ++ coordinateArray)
	}

	*kr { |numChannels=1 gate=0.0 x=0.0 y=0.0 z=0.0 coordinateArray|
		^this.multiNewList(['control', numChannels, gate, x, y, z] ++ coordinateArray)
	}

}
