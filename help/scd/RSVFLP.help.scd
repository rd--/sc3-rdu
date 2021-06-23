// rsvflp ; changing F
{var f = XLine.kr(20,20000,20,1)
;RSVFLP.ar(WhiteNoise.ar() * 0.1, f, 1)}

// rsvflp ; changing Q
{var q = Line.kr(2,0.0001,20,1)
;RSVFLP.ar(WhiteNoise.ar() * 0.1, 400, q)}

// rsvflp
{var f = SinOsc.kr(XLine.kr(0.7, 300, 20, 1), 0) * 3600 + 4000
;RSVFLP.ar(Saw.ar(200) * 0.1, f, 1)}
