// RDustR ; a = noise, b = impulses
{var a = RDustR.ar(iotMin: 0.0001, iotMax: 0.001) * 0.1
;var b = RDustR.ar(iotMin: 0.1, iotMax: 0.1) * 0.5
;[a,b]}

//---- RDustR ; c.f. impulse
{[Impulse.ar(freq: 1000, phase: 0) * 0.5, RDustR.ar(iotMin: 0.001, iotMax: 0.001)]}.plot(duration: 0.01)
