Ln : PseudoUgen {

	*ar { |start=0 end=1 dur=1|
		^Line.ar(start, end, dur, 1, 0, 0)
	}

	*kr { |start=0 end=1 dur=1|
		^Line.kr(start, end, dur, 1, 0, 0)
	}

	*new { |start=0 end=1 dur=1|
		^Ln.ar(start, end, dur)
	}

}
