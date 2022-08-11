Sw : PseudoUgen {

	*kr {
		arg index = 1;
		^ In.kr(12000 + index, 1)
	}

	*new {
		arg index = 1;
		^ Sw.kr(index)
	}

}
