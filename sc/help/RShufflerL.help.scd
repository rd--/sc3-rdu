/*
RShufflerL in fragmentSize maxDelay
Linear Shuffler.
Ordinarily this is used in parallel node banks.
*/

{var x = MouseX.kr(0.0001, 0.02)
;var y = MouseY.kr(0.001, 0.25, 1)
;RShufflerL.ar(SinOsc.ar(440, 0, 0.2), x, y)}.play

{var x = MouseX.kr(0.0001, 0.02)
;var y = MouseY.kr(0.001, 0.25, 1)
;var n = 6
;var f = x * Array.fill(n,{4.0.rand})
;var d = y * Array.fill(n,{4.0.rand})
;Mix(RShufflerL.ar(SinOsc.ar(440, 0, 0.2/n),f,d))}.play
