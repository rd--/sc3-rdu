ControlOut : PseudoUgen {

	*kr { |bus=0 channelsArray|
		^Out.kr(bus, channelsArray)
	}

	*new { |bus=0 channelsArray|
		^ControlOut.kr(bus, channelsArray.kr)
	}

}
