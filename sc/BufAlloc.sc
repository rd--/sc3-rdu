BufAlloc {

	*new { arg numChannels, numFrames;
		^LocalBuf(numFrames, numChannels)
	}

}
