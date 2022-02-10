// IRandN
Splay2.ar(SinOsc.ar(IRandN.ir(7,48,72).midiCps,0) * RandN.ir(7,0.05,0.10))

// IRandN ; c.f. RandN and round
Splay2.ar(SinOsc.ar(RandN.ir(7,48,72).round.midiCps,0) * RandN.ir(7,0.05,0.10))
