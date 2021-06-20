// RTLine ; linear ramp from 220 to 440 over 5 seconds, every 10 seconds
{SinOsc.ar(RTLine.kr(220,440,5,Impulse.kr(1/10,0)),0) * 0.1}

// RTLine ; linear ramp from 220 to 110 over 2 seconds, every 4 seconds
{SinOsc.ar(RTLine.kr(220,110,2,Impulse.kr(1/4,0)),0) * 0.1}

// RTLine ; linear ramp from 110 to 440 over 10 seconds, every 5 seconds ; reference tone in left channel
{SinOsc.ar([440.0,RTLine.kr(110,440,10,Impulse.kr(1/5,0))],0) * 0.1}

// RTLine ; start and end reset randomly every 4 seconds, ramp every trigger
{var trig = Impulse.kr(1/4, 0)
;var f0 = TExpRand.kr(110, 440, trig)
;var f1 = TExpRand.kr(110, 440, trig)
;Splay.ar(SinOsc.ar([f0,RTLine.kr(f0, f1, 4, trig),f1],0)) * [0.05,0.1,0.05]}

// RTLine ; reset end randomly every 4 seconds, start is previous end, ramp every trigger ; c.f. RTLineTo
{var trig = Impulse.kr(1/4, 0)
;var f1 = TExpRand.kr(110, 440, TDelay.kr(trig, ControlDur.ir))
;var f0 = Latch.kr(f1, trig)
;SinOsc.ar(RTLine.kr(f0, f1, 4, trig),0) * 0.1}

//---- drawings
{RTLine.kr(0,0.25,0.125,Impulse.kr(8,0))}.plot(duration: 0.5) // reset at line duration
{RTLine.kr(0,0.25,0.125,Impulse.kr(4,0))}.plot(duration: 0.5) // reset at twice line duration
{RTLine.kr(0,0.25,0.125,Impulse.kr(16,0))}.plot(duration: 0.5) // reset at half line duration
{RTLine.kr(0,0.25,0.125,Dust.kr(32))}.plot(duration: 0.5) // reset at random (fast)

//---- random end point
{var t = Impulse.kr(8,0);
RTLine.kr(0,TRand.kr(0,0.35,t),0.125,t)}.plot(duration: 0.5)

//---- random start and end points and duration
{var t = Dust.kr(32)
;var r = {TRand.kr(0.15,0.35,t)}
;RTLine.kr(r.value,r.value,0.125,t)}.plot(duration: 0.5)
