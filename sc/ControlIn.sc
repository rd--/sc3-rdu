ControlIn : PseudoUgen {

	*kr {
		arg numChan = 1, bus = 0;
		^In.kr(bus, numChan)
	}

	*new {
		arg numChan = 1, bus = 0;
		^ControlIn.kr(numChan, bus)
	}

}
