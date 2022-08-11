SinOscBank : PseudoUgen {

	*ar {
		arg freq, amp, phase;
		^Klang.ar(Ref.new([freq, amp, phase]), 1, 0)
	}

	*new {
		arg freq, amp, phase;
		^SinOscBank.ar(freq, amp, phase)
	}

}
