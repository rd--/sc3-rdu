// TXLine ; exponential ramp from 220 to 440 over 5 seconds, every 10 seconds
{SinOsc.ar(freq: TXLine.kr(start: 220, end: 440, dur: 5, trig: Impulse.kr(freq: 1/10, phase: 0)), phase: 0) * 0.1}

// TXLine ; linear ramp from 220 to 110 over 2 seconds, every 4 seconds
{SinOsc.ar(RTLine.kr(220,110,2,Impulse.kr(1/4,0)),0) * 0.1}

// TXLine ; start and end reset randomly every 4 seconds, ramp every trigger
{var trig = Impulse.kr(1/4, 0)
;var f0 = TExpRand.kr(110, 450, trig)
;var f1 = TExpRand.kr(110, 440, trig)
;Splay.ar(SinOsc.ar([f0,TXLine.kr(f0, f1, 4, trig),f1],0)) * [0.05,0.1,0.05]}
