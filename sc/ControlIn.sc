ControlIn {

	*new {
		arg numChan = 1, bus = 0;
		^In.kr(bus, numChan)
	}

}
