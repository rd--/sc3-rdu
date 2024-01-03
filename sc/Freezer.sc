Freezer : PureUGen {

	*ar { |bufnum=0 left=0 right=1 gain=1 increment=1 incrementOffset=0 incrementRandom=0 rightRandom=0 syncPhaseTrigger=0 randomizePhaseTrigger=0 numberOfLoops=4 mul=1 add=0|
		^this.multiNew('audio', bufnum, left, right, gain, increment, incrementOffset, incrementRandom, rightRandom, syncPhaseTrigger, randomizePhaseTrigger, numberOfLoops).madd(mul, add)
	}

}
