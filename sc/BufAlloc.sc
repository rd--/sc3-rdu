BufAlloc {

	*new { |numChannels numFrames|
		^LocalBuf(numFrames, numChannels)
	}

}
