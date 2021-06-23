RObxdFilter : UGen {
  *ar { arg in=0.0, cutoff=440.0, resonance=0.0, multimode=0.5, bandpass=0.0, fourpole=0.0;
      ^this.multiNew('audio', in, cutoff, resonance, multimode, bandpass, fourpole);
  }
}
