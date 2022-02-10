// RandN
SinOsc.ar(RandN.ir(2, 220, 226), 0) * RandN.ir(2, 0.05, 0.10)

// Rand ; dup
SinOsc.ar({ Rand.ir(220, 226)}.dup(2), 0) * ({ Rand.ir(0.05, 0.10) }.dup(2))

// Rand ; dup ; mul-add inputs
SinOsc.ar({ Rand.ir(220, 226) }.dup(2), 0, { Rand.ir(0.05, 0.10) }.dup(2))
