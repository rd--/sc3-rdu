// RIRandN
{Splay.ar(SinOsc.ar(RIRandN(7,48,72).midicps,0) * RRandN(7,0.05,0.10))}

// RRandN ; round
{Splay.ar(SinOsc.ar(RRandN(7,48,72).round.midicps,0) * RRandN(7,0.05,0.10))}
