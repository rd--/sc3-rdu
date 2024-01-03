TLine {

	*new { |start = 0.0, end = 1.0, dur = 10, trig = 0 |
		^TLine.ar(start, end, dur, trig);
	}

	*ar { |start = 0.0, end = 1.0, dur = 10, trig = 0 |
		var env = Env.new(levels: [start, start, end], times: [0, dur], curve: [\lin], releaseNode: nil, loopNode: nil, offset: 0);
		^EnvGen.ar(envelope: env, gate: trig, levelScale: 1.0, levelBias: 0.0, timeScale: 1.0, doneAction: 0);
	}

	*kr { |start = 0.0, end = 1.0, dur = 10, trig = 0 |
		var env = Env.new(levels: [start, start, end], times: [0, dur], curve: [\lin], releaseNode: nil, loopNode: nil, offset: 0);
		^EnvGen.kr(envelope: env, gate: trig, levelScale: 1.0, levelBias: 0.0, timeScale: 1.0, doneAction: 0);
	}

}
