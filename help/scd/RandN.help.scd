// RandN
SinOsc.ar(RandN.ir(2, 220, 226), 0) * RandN.ir(2, 0.05, 0.10)

// Rand ; !
SinOsc.ar({ Rand.ir(220, 226)} ! 2, 0) * ({ Rand.ir(0.05, 0.10) } ! 2)

// Rand ; ! ; mul-add inputs
SinOsc.ar({ Rand.ir(220, 226) } ! 2, 0, { Rand.ir(0.05, 0.10) } ! 2)
