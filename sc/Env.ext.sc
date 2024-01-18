+ Env {

	asEnvGen { |gate|
		var rate = gate.rate;
		(rate == 'scalar').if {
			rate = 'control'
		};
		^EnvGen.perform(rate.rateToSelector, this, gate, 1, 0, 1, 0)
	}

}
