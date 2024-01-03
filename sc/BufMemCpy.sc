BufMemCpy {

	*message { |bufferNumber numFrames numChannels sampleRate bufferData|
		^[
			'/b_gen',
			bufferNumber, // Int
			"memcpy", // String
			numFrames, // Int
			numChannels, // Int
			sampleRate, // Float
			bufferData // Blob
		]
	}

}
