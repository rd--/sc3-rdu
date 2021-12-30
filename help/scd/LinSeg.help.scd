// LinSeg
var tr = Impulse.ar(1 / 6, 0);
SinOsc.ar(LinSeg.ar(tr, [220, 1, 880, 5, 220]), 0) * LinSeg.ar(tr, [0, 0.001, 0.1, 6, 0.001])

// LinSeg
var tr = Impulse.ar(1 / 4, 0);
SinOsc.ar(LinSeg.ar(tr, [220, 1, 880, 2, 110, 1, 220]), 0) * LinSeg.ar(tr, [0, 0.001, 0.1, 4, 0.001])

// LinSeg
var tr = Impulse.ar(1 / 3, 0);
var f0 = TRand.ar(110, 440, tr);
var f1 = TRand.ar(110, 440, tr);
SinOsc.ar(LinSeg.ar(tr, [f0, 1, f1, 2, f0]), 0) * LinSeg.ar(tr, [0, 0.01, 0.1, 3, 0.01])

// LinSeg
var tr = Impulse.ar(1 / 3, 0);
var f0 = TRand.ar(220, 440, tr);
var f1 = TRand.ar(660, 880, tr);
var f2 = TRand.ar(110, 220, tr);
SinOsc.ar(LinSeg.ar(tr, [f0, 1, f1, 1, f2, 1, f0]), 0) * LinSeg.ar(tr, [0, 0.01, 0.1, 3, 0.01])

