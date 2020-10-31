// ExpRandN
{SinOsc.ar(ExpRandN(2,110,220),0) * RandN(2,0.05,0.10)}

// ExpRand!n
{SinOsc.ar({ExpRand(110,220)}!2,0) * ({ExpRand(0.05,0.10)}!2)}

// ExpRandN - n node klang synthesis
{var n = 120
;var f = ExpRandN(n,40,18000)
;var a = ExpRandN(n,0.1,0.3)
;var p = RandN(n,-1,1)
;{Klang.ar(`[f,a,p]) * 0.01}.dup}
