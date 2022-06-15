// TLinRand ; n linearly distributed random number every second
var n = 12;
var tr = Impulse.kr(1, 0);
Splay2.ar(SinOsc.ar({ TLinRand.kr(440, 880, 0, tr) }.dup(n), 0) * 0.1)
