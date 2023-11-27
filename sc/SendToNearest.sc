SendToNearest : PureUGen {

	*ar {
		arg coordinateArray, trig = 0.0, x = 0.0, y = 0.0, z = 0.0, inputArray;
		^this.multiNewList(['audio', coordinateArray.size, trig, x, y, z] ++ inputArray);
	}

}
