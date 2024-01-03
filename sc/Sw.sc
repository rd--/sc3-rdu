Sw : PseudoUgen {

	*kr { |index=1|
		^ In.kr(12000 + index, 1)
	}

	*new { |index=1|
		^ Sw.kr(index)
	}

}
