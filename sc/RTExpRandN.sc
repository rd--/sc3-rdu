RTExpRandN : MultiOutUGen {
    *kr {
        arg numChannels = 2, lo = 0, hi = 1, trigger = 0;
        ^this.multiNew('control', numChannels, lo, hi, trigger)
    }
    init {
        arg numChannels, lo, hi, trigger;
        inputs = [lo, hi, trigger];
        ^this.initOutputs(numChannels, rate)
    }
}
