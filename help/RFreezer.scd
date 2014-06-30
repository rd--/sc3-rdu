// Allocate signal buffer.
f = Platform.systemAppSupportDir +/+ "sounds/a11wlk01.wav";
s.sendMsg("/b_allocRead", 10, f, 0, -1);

// Instrument definition
SynthDef("RFreezer",{
    arg out=0, bufnum=0, left=0, right=1, gain=1,
        increment=1, incrementOffset=0, incrementRandom=0, rightRandom=0,
        phaseSynchronize=0, phaseRandomize=0, numberOfLoops=4;
    Out.ar(out,RFreezer.ar(bufnum, left, right, gain, [increment, increment+0.01],
        incrementOffset, incrementRandom, rightRandom,
        phaseSynchronize, phaseRandomize,
        numberOfLoops))}).add;

// Mouse{XY} controller definitions.
SynthDef("MouseControl", {
    var left = MouseX.kr(0,1) * (1.0 - size);
    var size = MouseY.kr(0.05, 0.95);
    Out.kr(32, max(left, 0.0));
    Out.kr(33, min(left+size, 1.0))}).add;

// Put default values onto control busses and Start instrument.
s.sendMsg("/c_setn", 32, 10, 0.3, 0.4, 0.36, 0.35, 0.02, 0.003, 0.34, -0.5, -0.5, 6);
s.sendMsg("/s_new", "RFreezer", 1003, 1, 0, "bufnum", 10, "gain", 0.1);
s.sendMsg("/n_mapn", 1003, 2, 32, 10);
s.sendMsg("/s_new", "MouseControl", 1004, 1, 0);

// Free nodes and buffer.
s.sendMsg("/n_free", 1003);
s.sendMsg("/n_free", 1004);
s.sendMsg("/b_free", 10);
