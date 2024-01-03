ObxdFilter : Filter {

	*ar { |in=0 cutoff=440 resonance=0 multimode=0.5 bandpass=0 fourpole=0|
		^this.multiNew('audio', in, cutoff, resonance, multimode, bandpass, fourpole);
	}

}
