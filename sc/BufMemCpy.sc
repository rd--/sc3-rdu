BufMemCpy {

	*encodeFloat32Array { |anArray littleEndian|
		var stream = CollStream(Int8Array());
		littleEndian.if {
			anArray.do { |each|
				stream.putFloatLE(each)
			}
		} {
			anArray.do { |each|
				stream.putFloat(each)
			}
		};
		^stream.contents
	}

	*message { |bufferNumber numFrames numChannels sampleRate bufferData byteSwap|
		^[
			'/b_gen',
			bufferNumber, // Int
			"memcpy", // String
			numFrames, // Int
			numChannels, // Int
			sampleRate, // Float
			bufferData, // Blob (Int8Array)
			byteSwap // Int
		]
	}

}
