// IRandN
Splay.ar(SinOsc.ar(IRandN.ir(7,48,72).midicps,0) * RandN.ir(7,0.05,0.10))

// IRandN ; c.f. RandN and round
Splay.ar(SinOsc.ar(RandN.ir(7,48,72).round.midicps,0) * RandN.ir(7,0.05,0.10))
