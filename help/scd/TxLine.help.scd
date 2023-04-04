// TxLine ; psuedo-ugen ; exponential ramp from 220 to 440 over 5 seconds, every 10 seconds
SinOsc.ar(
	freq: TxLine.kr(start: 220, end: 440, dur: 5, trig: Impulse.kr(freq: 1/10, phase: 0)),
	phase: 0)
 * 0.1

// TLine ; linear ramp from 220 to 110 over 2 seconds, every 4 seconds
SinOsc.ar(TLine.kr(220, 110, 2, Impulse.kr(1/4, 0)), 0) * 0.1

// TxLine ; start and end reset randomly every 4 seconds, ramp every trigger
var trig = Impulse.kr(1/4, 0);
var f0 = TExpRand.kr(110, 450, trig);
var f1 = TExpRand.kr(110, 440, trig);
Splay.ar(SinOsc.ar([f0, TxLine.kr(f0, f1, 4, trig), f1], 0)) * [0.05, 0.1, 0.05]

//---- drawings
{ TxLine.kr(0.001, 0.25, 0.125, Impulse.kr(8, 0)) }.plot(duration: 0.5) // reset at line duration
{ TxLine.kr(0.001, 0.25, 0.125, Impulse.kr(4, 0)) }.plot(duration: 0.5) // reset at twice line duration
{ TxLine.kr(0.001, 0.25, 0.125, Impulse.kr(16, 0)) }.plot(duration: 0.5) // reset at half line duration
{ TxLine.kr(0.001, 0.25, 0.125, Dust.kr(32)) }.plot(duration: 0.5) // reset at random (fast)

//---- random end point
{
	var t = Impulse.kr(8, 0);
	TxLine.kr(0.001, TRand.kr(0, 0.35, t), 0.125, t)
}.plot(duration: 0.5)

//---- random start and end points and duration
{
	var t = Dust.kr(24);
	var r = { TRand.kr(0.001, 0.65, t) };
	TxLine.kr(r.value, r.value, 0.125, t)
}.plot(duration: 0.5)
