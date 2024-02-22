// ExpRandN
SinOsc.ar(ExpRandN.ir(2, 110, 220), 0) * RandN.ir(2, 0.05, 0.10)

// ExpRand - !
SinOsc.ar({ ExpRand(110, 220) } ! 2, 0) * ({ ExpRand(0.05, 0.10) } ! 2)

// ExpRandN - n node klang synthesis
var n = 120;
var f = ExpRandN.ir(n, 40, 18000);
var a = ExpRandN.ir(n, 0.1, 0.3);
var p = RandN.ir(n, -1, 1);
{
	Klang.ar(Ref.new([f, a, p])) * 0.01
} ! 2
