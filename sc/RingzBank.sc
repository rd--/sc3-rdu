RingzBank : PseudoUgen {

	*ar { |input freq amp=1 time=1|
		^Klank.ar(Ref.new([freq, amp, time]), input, 1, 0, 1)
	}

	*new { |input freq amp=1 time=1|
		^RingzBank.ar(input, freq, amp, time)
	}

}
