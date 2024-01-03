ControlIn : PseudoUgen {

	*kr { |numChan=1 bus=0|
		^In.kr(bus, numChan)
	}

	*new { |numChan=1 bus=0|
		^ControlIn.kr(numChan, bus)
	}

}
