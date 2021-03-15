// RDustR ; a = noise, b = impulses
{var a = ar(RDustR,0.0001,0.001) * 0.1
;var b = ar(RDustR,0.1,0.1) * 0.5
;[a,b]}

//---- RDustR ; c.f. impulse
{[ar(Impulse,1000,0) * 0.5,ar(RDustR,0.001,0.001)]}.plot(0.01)
