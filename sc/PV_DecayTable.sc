PV_DecayTable : PV_ChainUGen {
    *new {
        arg fft_buf=0.0, decay_rate_buf=0.0, history_buf=0.0;
        ^this.multiNew('control', fft_buf, decay_rate_buf, history_buf);
    }
}
