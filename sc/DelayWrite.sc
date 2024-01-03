DelayWrite : PseudoUgen {

	*ar { |bufnum=0 in|
		^RecordBuf.ar([in], bufnum, 0, 1, 0, 1, 1, 1, 0)
	}

	*new { |bufnum=0 in|
		^DelayWrite.ar(bufnum, in)
	}

}
