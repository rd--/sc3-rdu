// SinOscBank ; Klang
var f1 = [221, 614, 1145, 1804, 2577, 3456, 4419];
var f2 = [977, 1003, 1390, 1414, 1432, 1465, 1748, 1834, 1919, 1933, 1987, 2096, 2107, 2202, 2238, 2280, 2400, 2435, 2507, 2546, 2608, 2652, 2691, 2708];
[f1, f2].collect({
    arg f;
    var o = SinOscBank.ar(f, 1 / f * { Rand.ir(0, 0.1) }.dup(f.size) * f.size * f.size, [0]);
    Pan2.ar(o, LFNoise2.ar(0.25), LFNoise2.ar(0.5) / 4 + 0.25)
}).mix
