LinRandN : MultiOutUGen {
    *ir {
        arg numChannels = 2, lo = 0, hi = 1, minmax = 0;
        ^this.multiNew('scalar', numChannels, lo, hi, minmax)
    }
    init {
        arg numChannels, lo, hi, minmax;
        inputs = [lo, hi, minmax];
        ^this.initOutputs(numChannels, rate)
    }
}
