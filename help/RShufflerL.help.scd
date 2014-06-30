// Unary node
{var o = SinOsc.ar([440,441], 0) * 0.2
;var x = MouseX.kr(0.0001, 0.02)
;var y = MouseY.kr(0.001, 0.25, 1)
;var s = RShufflerL.ar(o, x, y)
;Out.ar(0,s)}.play

// Parallel node banks
{var n = 6
;var o = SinOsc.ar([440,441], 0) * 0.2
;var x = MouseX.kr(0.0001, 0.02)
;var y = MouseY.kr(0.001, 0.25, 1)
;var f = x * Array.fill(n,{4.0.rand})
;var d = y * Array.fill(n,{4.0.rand})
;Out.ar(0,Splay.ar(RShufflerL.ar(o,f,d)))}.play
