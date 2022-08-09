Select2 {

	*new {
		arg predicate, ifTrue, ifFalse;
		^(predicate * (ifTrue - ifFalse)) + ifFalse
	}

}
