// SvfHp ; changing F
var f = XLine.kr(20, 20000, 20, 1);
SvfHp.ar(WhiteNoise.ar() * 0.1,  f,  1)

// SvfHp ; changing Q
var q = Line.kr(2, 0.0001, 20, 1);
SvfHp.ar(WhiteNoise.ar() * 0.1,  400,  q)

// SvfHp
var f = SinOsc.kr(XLine.kr(0.7,  300,  20,  1),  0) * 3600 + 4000;
SvfHp.ar(Saw.ar(200) * 0.1,  f,  1)
