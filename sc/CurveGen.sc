CurveGen {
    *new {
        arg gate, levels, times, curves;
        ^EnvGen.ar(Env(levels, times, curves, nil, nil, 0), gate, 1, 0, 1, 0);
    }
    *ar {
        arg gate, levels, times, curves;
        ^this.new(gate, levels, times, curves)
    }
    *kr {
        arg gate, levels, times, curves;
        ^EnvGen.kr(Env(levels, times, curves, nil, nil, 0), gate, 1, 0, 1, 0);
    }
}
