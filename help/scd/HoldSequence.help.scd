// HoldSequence ; audio rate ; https://sccode.org/1-4Qy ; f0 ; 0340
var c = SinOscFB.ar(1 / [12, 8], 0) + 3 / 24;
var m = HoldSequence.ar([DC.ar(0), 8, 5, 1, 5, 4, 5] * (c * 18).round, c) + 60;
AllpassN.ar(SinOscFB.ar(m.midicps, c * 2), 0.2, 0.2, 1) / 2

// HoldSequence ; control rate ; https://sccode.org/1-4Qy ; f0 ; 0340
var c = SinOscFB.kr(1 / [12, 8], 0) + 3 / 24;
var m = HoldSequence.kr([0, 8, 5, 1, 5, 4, 5] * (c * 18).round, c) + 60;
AllpassN.ar(SinOscFB.ar(m.midicps, c * 2), 0.2, 0.2, 1) / 2
