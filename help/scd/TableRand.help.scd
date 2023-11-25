// TableRand
var tbl = { | trig dist lo hi |
	TableRand.kr(trig, dist.asRandomTable(512).as(LocalBuf)).linlin(0, 1, lo, hi)
};
var tr = Dust.kr(MouseX.kr(7, [11, 23], 1, 0.2));
var carFreq = [
	tbl.(tr, [1,0,0], 111, 555),
	tbl.(tr, [0,1,1], 111, 555)
];
var modFreq = carFreq * [
	tbl.(tr, [1,0,1], 1, 23),
	tbl.(tr, [0,1,0], 1, 23)
].round;
var index = [
	tbl.(tr, [0,0,1], 1, 23),
	tbl.(tr, [1,0,0], 1, 23)
];
GrainFM.ar(1, tr, 1 / 5, carFreq, modFreq, index, 0, -1, 512).sum / 23
