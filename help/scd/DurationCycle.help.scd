// DurationCycle
var x = DurationCycle.ar([5, 2, 3] / 5);
SinOsc.ar(x * 1000 + 200, 0) * 0.1 * x

// ---- DurationPulse ; plot ; note drift
{ DurationCycle.ar([5, 2, 3] / 1000) }.plot(0.03)

// ---- DurationCycle ; plot
DurationCycle.env([5, 2, 3]).plot
