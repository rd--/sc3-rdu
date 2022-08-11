Select2 : PseudoUgen {

	*new {
		arg predicate, ifTrue, ifFalse;
		^(predicate * (ifTrue - ifFalse)) + ifFalse
	}

}
