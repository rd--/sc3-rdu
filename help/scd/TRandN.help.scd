// TRandN ; n uniform random numbers every second
var n = 12;
var tr = Impulse.kr(1, 0);
Splay2.ar(SinOsc.ar(TRandN.kr(n, 440, 880, tr), 0) * 0.1)
