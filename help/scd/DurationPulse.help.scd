// DurationPulse
var x = DurationPulse.ar([5, 2, 3] / 5);
SinOsc.ar(x + 1 * 900 + 300, 0) * 0.1 * x

// ---- DurationPulse ; plot ; note offset
{ DurationPulse.ar([5, 2, 3] / 1000) }.plot(0.03)

// ---- DurationPulse ; plot
DurationPulse.env([5, 2, 3]).plot
