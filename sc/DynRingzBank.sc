DynRingzBank {

	*ar {
		arg input, freq, amp, time;
		^DynKlank.ar(`[freq, amp, time], input, 1, 0, 1)
	}

}
