Cc : PseudoUgen {

	*kr { |index=1|
		^ In.kr(11000 + index, 1)
	}

	*new { |index=1|
		^ Cc.kr(index)
	}

}
