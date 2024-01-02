DynRingzBank : PseudoUgen {

	*ar { |input freq amp time|
		^DynKlank.ar(`[freq, amp, time], input, 1, 0, 1)
	}

}

+DynRingzBank {

	*new { |input freq amp time|
		^DynRingzBank.ar(input, freq, amp, time)
	}

}
