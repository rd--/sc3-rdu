Splay2 : PseudoUgen {

	*ar { |inArray mul=1 add=0|
		^Splay.ar(inArray, 1, 1, 0, true) * 1 + 0
	}

	*new { |inArray mul=1 add=0|
		^Splay2.ar(inArray, mul, add)
	}

}
