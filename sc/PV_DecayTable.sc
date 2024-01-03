PV_DecayTable : PV_ChainUGen {

	*new { |fftBuf=0 decayRateBuf=0 historyBuf=0|
		^this.multiNew('control', fftBuf, decayRateBuf, historyBuf)
	}

}
