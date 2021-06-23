RFreezer : UGen {
 *ar { arg  bufnum = 0.0, left = 0.0, right = 1.0, gain = 1.0, increment = 1.0, incrementOffset = 0.0, incrementRandom = 0.0, rightRandom = 0.0, syncPhaseTrigger = 0.0, randomizePhaseTrigger = 0.0, numberOfLoops = 4, mul = 1.0, add = 0.0;
  ^this.multiNew('audio', bufnum, left, right, gain, increment, incrementOffset, incrementRandom, rightRandom, syncPhaseTrigger, randomizePhaseTrigger, numberOfLoops).madd(mul, add);
 }
}
