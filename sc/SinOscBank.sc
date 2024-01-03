SinOscBank : PseudoUgen {

	*ar { |freq amp phase|
		^Klang.ar(Ref.new([freq, amp, phase]), 1, 0)
	}

	*new { |freq amp phase|
		^SinOscBank.ar(freq, amp, phase)
	}

}
