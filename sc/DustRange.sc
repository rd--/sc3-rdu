DustRange : UGen {

	*ar { |iotMin=0.1 iotMax=1.0|
		^this.multiNew('audio', iotMin, iotMax)
	}

}
