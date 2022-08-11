ControlOut : PseudoUgen {

	*kr {
		arg bus = 0, channelsArray;
		^Out.kr(bus, channelsArray)
	}

	*new {
		arg bus = 0, channelsArray;
		^ControlOut.kr(bus, channelsArray)
	}

}
