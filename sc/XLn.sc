XLn : PseudoUgen {

	*ar { |start=1 end=2 dur=1|
		^XLine.ar(start, end, dur, 1, 0, 0)
	}

	*kr { |start=1 end=2 dur=1|
		^XLine.kr(start, end, dur, 1, 0, 0)
	}

	*new { |start=1 end=2 dur=1|
		^XLn.ar(start, end, dur)
	}

}
