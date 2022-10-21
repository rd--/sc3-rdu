// https://scsynth.org/t/6613
Tanh2 {
	*new {
		arg signal, steepness = 1, range = 1;
		var exponent = steepness * 2 * signal + range.log;
		var exponentExp = exponent.exp;
		var numerator = range * exponentExp - 1;
		var denominator = range.reciprocal + exponentExp;
		^ numerator / denominator
	}
}
