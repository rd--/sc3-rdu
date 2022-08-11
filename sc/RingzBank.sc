RingzBank : PseudoUgen {

	*ar {
		arg input, freq, amp, time;
		^Klank.ar(Ref.new([freq, amp, time]), input, 1, 0, 1)
	}

	*new {
		arg input, freq, amp, time;
		^RingzBank.ar(input, freq, amp, time)
	}

}
