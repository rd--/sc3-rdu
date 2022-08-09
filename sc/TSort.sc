TSort : MultiOutUGen {

	init {
		arg ... i;
		inputs = i;
		^this.initOutputs(i.size - 1, rate)
	}

	*ir {
		arg trigger = 0.0, inputs;
		^this.multiNewList(['scalar', trigger] ++ inputs);
	}

	*kr {
		arg trigger = 0.0, inputs;
		^this.multiNewList(['control', trigger] ++ inputs);
	}

	*ar {
		arg trigger = 0.0, inputs;
		^this.multiNewList(['audio', trigger] ++ inputs);
	}

}
