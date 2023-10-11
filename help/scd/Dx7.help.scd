// Dx7 ; event control ; data at local buffer
var voiceData = [
    [25, 21, 98, 38, 99,  0, 99,  0, 36, 17, 87,  2,  1, 0, 0, 0, 59,  0,  1, 1, 8],
    [66, 69, 60, 35,  0,  0, 98,  0,  0,  0,  4,  0,  0, 0, 0, 1, 90,  0,  1, 0, 8],
    [25, 21, 98, 38, 99,  0, 99,  2, 35, 15, 79,  3,  1, 1, 0, 0, 91,  1,  0, 0, 6],
    [97, 69, 60, 35, 99, 91, 98,  0,  0,  0,  0,  0,  0, 0, 0, 1, 68,  0, 22, 0, 7],
    [78, 63, 53, 28, 99, 52, 62,  3, 38, 11, 80,  3,  0, 0, 0, 0, 77,  0,  7, 0, 0],
    [98, 56, 63, 23, 99, 89, 74,  2,  0,  4,  1,  0,  0, 0, 0, 0, 99,  0,  1, 0, 7],
    [99, 99, 99, 99, 50, 50, 50, 50,  3,  2,  1, 29, 99, 1, 0, 0,  0,  1, 24]
].flatten;
var buf = voiceData.asLocalBuf;
var voiceFunc = { | e |
	var x0 = Latch.kr(in: e.x, trig: e.w);
	var dx7 = Dx7.ar(bufnum: buf, on: e.w, off: 0, data: 0, vc: 0, mnn: e.p * 127, vel: e.z, pw: 0x2000 * (e.x - x0), mw: 0, bc: 0, fc: 0);
	Pan2.ar(in: dx7, pos: (e.i * 2 - 1), level: e.z)
};
Voicer.ar(numVoices: 16, voiceFunc: voiceFunc).sum

//---- ui
ContinuousEventUi(frameRate: 25, areaWidth: 230, areaHeight: 130, areaScaling: 2.5, gridFileName: nil, deriveXFromP: false).makeWindow;

//---- event/routine control ; event pattern ; c.f. CmdPeriod.freeServers or R.cmdPeriodRetainServerState
Pbind(
	'w', 1,
	'p', (Pwhite([4, 6, 7], 7) * 12 + Pbrown(0,5).degreeToKey(Scale.yu('pythagorean'))) / 127,
	'y', Pbrown(),
	'z', Pbrown(0.0, 0.2),
	'i', Pbrown(),
	'dur', Pbrown(0.05, 0.15)
).continuousEventPlayer(16)

//---- event/routine control ; event function ; c.f. CmdPeriod.freeServers or R.cmdPeriodRetainServerState
{
	(
		w: 1,
		p: { (36 + 48.rand) / 127 } ! (5.rand + 1),
		y: 1.0.rand,
		z: 0.25.rand,
		i: 1.0.rand,
		dur: 1.0.rand
	)
}.continuousEventPlayer(16)

//---- event/routine control ; event pattern ; c.f. CmdPeriod.freeServers or R.cmdPeriodRetainServerState
Pbind(
	'w', 1,
	'p', (
		Pwhite([3, 4, 7], 8) * 12 +
		Pwrand([0, 1, 2, 3, 4, 5], [2, 1, 2, 3, 1, 2].normalizeSum, inf).degreeToKey(Scale.yu('pythagorean'))
	) / 127,
	'y', Pbrown([0, 0.5], [0.5, 1]),
	'z', Pbrown(0.05, 0.25),
	'i', Pwhite(),
	'dur', Pwrand([0.1, 0.2, 0.3, 0.4, 0.6], [16, 8, 4, 2, 1].normalizeSum, inf)
).continuousEventPlayer(16)

//---- midi control ; make graph and add synthdef, voice data at local buffer
var vc = [
	[25, 21, 98, 38, 99,  0, 99,  0, 36, 17, 87, 2, 1, 0, 0, 0, 59,  0,  1, 1, 8],
	[66, 69, 60, 35,  0,  0, 98,  0,  0,  0,  4, 0, 0, 0, 0, 1, 90,  0,  1, 0, 8],
	[25, 21, 98, 38, 99,  0, 99,  2, 35, 15, 79, 3, 1, 1, 0, 0, 91,  1,  0, 0, 6],
	[97, 69, 60, 35, 99, 91, 98,  0,  0,  0,  0, 0, 0, 0, 0, 1, 68,  0, 22, 0, 7],
	[78, 63, 53, 28, 99, 52, 62,  3, 38, 11, 80, 3, 0, 0, 0, 0, 77,  0,  7, 0, 0],
	[98, 56, 63, 23, 99, 89, 74,  2,  0,  4,  1, 0, 0, 0, 0, 0, 99,  0,  1, 0, 7],
	[99, 99, 99, 99, 50, 50, 50, 50, 3, 2, 1, 29, 99, 1, 0, 0, 0, 1, 24],
];
var buf = LocalBuf.newFrom(vc.flatten);
var gr = {
	arg bus=0, gate=1, reset=0, data=0, prg=0, mnn=60, vel=99, pw=0, mw=0, bc=0, fc=0, pan=0, vol=1;
	var sig = Dx7.ar(buf, gate, reset, data, prg, mnn, vel, pw, mw, bc, fc);
	DetectSilence.ar(sig, 0.001, 0.1, 1); /*mrg*/
	Out.ar(bus, Pan2.ar(sig, pan, vol))
}
var sy = SynthDef("rdx7-vc-gt", gr);
sy.add

// setup midi (if required)
MIDIIn.connectAll

// simple note on/off listeners, no voice logic, w/ tuning table
var syn = "rdx7-vc-gt";
var mem = Array.newClear(128);
var scl = Scale.chromatic(Tuning.at(\mean4)).semitones; // [0, 0.755, 1.93, 3.105, 3.86, 5.035, 5.79, 6.965, 7.72, 8.895, 10.07, 10.82]
var tun = 0.series(12,120).collect { | n | n + scl }.flatten;
MIDIFunc.noteOn({ | vel mnn ch src |
	var nid = s.nodeAllocator.alloc;
	mem.put(mnn,nid);
	["note-on", mnn, vel, nid, tun.at(mnn) - mnn].postln;
	s.sendMsg("/s_new", syn, nid, 0, 1, "mnn", tun.at(mnn), "vel", vel, "gate", 1)
}, nil, 0);
MIDIFunc.noteOff({ | vel  mnn  ch  src |
	var nid = mem.at(mnn);
	["note-off", mnn, vel, nid].postln;
	s.sendMsg("/n_set", nid, "gate", 0)
}, nil, 0)

// cleanup
CmdPeriod.run

//----
Server.default.dumpOSC(1)
CmdPeriod.freeServers = false
