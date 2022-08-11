Cc : PseudoUgen {

	*kr {
		arg index = 1;
		^ In.kr(11000 + index, 1)
	}

	*new {
		arg index = 1;
		^ Cc.kr(index)
	}

}
