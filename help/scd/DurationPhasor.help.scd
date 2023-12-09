// DurationPhasor
var x = DurationPhasor.ar([5, 2, 3] / 5);
SinOsc.ar(x + 1 * 900 + 300, 0) * 0.1 * x

// ---- DurationPhasor ; plot ; note drift
{ DurationPhasor.ar([5, 2, 3] / 1000) }.plot(0.03)

// ---- DurationPhasor ; plot
DurationPhasor.env([5, 2, 3]).plot
