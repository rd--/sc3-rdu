TScramble : MultiOutUGen {
    *ir {
        arg trigger = 0.0, inputs;
        ^this.multiNewList(['scalar', trigger] ++ inputs);
    }
    *kr {
        arg trigger = 0.0, inputs;
        ^this.multiNewList(['control', trigger] ++ inputs);
    }
    init {
        arg ... i;
        inputs = i;
        ^this.initOutputs(i.size - 1, rate)
    }
}
