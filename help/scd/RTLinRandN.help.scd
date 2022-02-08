// RTLinRandN ; n linearly distributed random numbers every second
var n = 12;
var tr = Impulse.kr(1,0);
Splay.ar(SinOsc.ar(RTLinRandN.kr(n,440,880,0,tr),0) * 0.1)
