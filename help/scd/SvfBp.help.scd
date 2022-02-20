// SvfBp ; changing F
var f = XLine.kr(20, 20000, 20, 1);
SvfBp.ar(WhiteNoise.ar() * 0.1,  f,  1)

// SvfBp ; changing Q
var q = Line.kr(2, 0.0001, 20, 1);
SvfBp.ar(WhiteNoise.ar() * 0.1,  400,  q)

// SvfBp
var f = SinOsc.kr(XLine.kr(0.7,  300,  20,  1),  0) * 3600 + 4000;
SvfBp.ar(Saw.ar(200) * 0.1,  f,  1)
