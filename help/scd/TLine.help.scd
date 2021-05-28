// TLine ; linear ramp from 220 to 440 over 5 seconds, every 10 seconds
{SinOsc.ar(TLine.kr(220,440,5,Impulse.kr(1/10,0)),0) * 0.1}

// TLine ; linear ramp from 220 to 110 over 2 seconds, every 4 seconds
{SinOsc.ar(TLine.kr(220,110,2,Impulse.kr(1/4,0)),0) * 0.1}

// TLine ; linear ramp from 110 to 440 over 10 seconds, every 5 seconds ; reference tone in left channel
{SinOsc.ar([440.0,TLine.kr(110,440,10,Impulse.kr(1/5,0))],0) * 0.1}

// TLine ; start and end reset randomly every 4 seconds, ramp every trigger
{var trig = Impulse.kr(1/4, 0)
;var f0 = TExpRand.kr(110, 440, trig)
;var f1 = TExpRand.kr(110, 440, trig)
;Splay.ar(SinOsc.ar([f0,TLine.kr(f0, f1, 4, trig),f1],0)) * [0.05,0.1,0.05]}
