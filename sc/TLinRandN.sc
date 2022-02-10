TLinRandN : MultiOutUGen {
    *kr {
        arg numChannels = 2, lo = 0, hi = 1, minmax = 0, trigger = 0;
        ^this.multiNew('control', numChannels, lo, hi, minmax, trigger)
    }
    init {
        arg numChannels, lo, hi, minmax, trigger;
        inputs = [lo, hi, minmax, trigger];
        ^this.initOutputs(numChannels, rate)
    }
}
