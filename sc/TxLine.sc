TxLine : PseudoUgen {

	*ar { |start=0.0 end=1.0 dur=10 trig=0|
		var env = Env.new(levels: [start, start, end], times: [0, dur], curve: ['exp']);
		^EnvGen.ar(envelope: env, gate: trig, levelScale: 1.0, levelBias: 0.0, timeScale: 1.0, doneAction: 0)
	}

	*kr { |start=0.0 end=1.0 dur=10 trig=0|
		var env = Env.new(levels: [start, start, end], times: [0, dur], curve: ['exp']);
		^EnvGen.kr(envelope: env, gate: trig, levelScale: 1.0, levelBias: 0.0, timeScale: 1.0, doneAction: 0)
	}

	*new { |start=0.0 end=1.0 dur=10 trig=0|
		^TxLine.ar(start, end, dur, trig)
	}

	/*
	*kr { |start=0.0 end=1.0 dur=10 trig=0|
		^LinExp.kr(Sweep.kr(trig, 1 / dur), 0, 1, start, end);
	}
	*/

}
