Splay2 : PseudoUgen {

	*ar {
		arg inArray;
		^Splay.ar(inArray, 1, 1, 0, true)
	}

	*new {
		arg inArray;
		^Splay2.ar(inArray)
	}

}
