// RRandN
{SinOsc.ar(RRandN(2,220,226),0) * RRandN(2,0.05,0.10)}

// Rand!n
{SinOsc.ar({Rand(220,226)}!2,0) * ({Rand(0.05,0.10)}!2)}

// Rand!n - mul-add inputs
{SinOsc.ar({Rand(220,226)}!2,0,{Rand(0.05,0.10)}!2)}
