DynRingzBank : PseudoUgen {

	*ar {
		arg input, freq, amp, time;
		^DynKlank.ar(`[freq, amp, time], input, 1, 0, 1)
	}

	*new {
		arg input, freq, amp, time;
		^DynRingzBank.ar(input, freq, amp, time)
	}

}
