Select2 : PseudoUgen {

	*new { |predicate ifTrue ifFalse|
		^(predicate * (ifTrue - ifFalse)) + ifFalse
	}

}
