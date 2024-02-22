// Release ; fixed duration envelope that releases (deletes) the sound on completion
Release.ar(SinOsc.ar(440, 0) * 0.1, 0.01, 3, 7)

// Release ; keywords
Release.ar(in: SinOsc.ar(freq: 440, phase: 0) * 0.1, attackTime: 0.01, dur: 3, releaseTime: 7)

//---- Release ; process ; requires=fork (i.e. sclang-fork-region)
9.do {
	{
		Release.ar(
			Pan2.ar(SinOsc.ar(Rand(200, 400), 0), Rand(-1, 1), Rand(0.01, 0.1)),
			0.01,
			3,
			7
		)
	}.play;
	3.seconds.wait
}
