> import Sound.SC3.ID
> import Sound.SC3.UGen.External.RDU

> Sound.SC3.UGen.DB.u_summary rDelayMap_dsc

Allocate buffer, required for all examples below.

> withSC3 (async (b_alloc 0 88200 1))

Zero buffer (transitioning between examples may require the buffer to
be cleared)

> withSC3 (async (b_zero 0))

Simple delay (static)

> let {a = mce [-1,0,0,0.5,1,-1,0,1]
>     ;x = mouseX KR 110 440 Linear 0.1
>     ;y = mouseY KR 0.0 0.2 Linear 0.1
>     ;o = sinOsc AR x 0 * y }
> in audition (out 0 (mce [rDelayMap 0 o 0 a,o]))

Simple feedback circuit (static)

> let {n = whiteNoise 'α' AR
>     ;s = decay (impulse AR (5/4) 0) 0.1 * n * 0.2
>     ;a = mce [-1,0,0,1,1/9,0,1,8/9,1,-1,0,1]}
> in audition (out 0 (rDelayMap 0 s 0 a))

Simple feedback circuit (dynamic)

> let {n = whiteNoise 'α' AR
>     ;s = decay (impulse AR (mce [1/3,5/4]) 0) 0.1 * n * 0.2
>     ;x = mouseX KR 0.05 1.05 Linear 0.1
>     ;y = mouseY KR 0.05 0.95 Linear 0.1
>     ;a = mce [-1,0,0,1,y,0,1,x,1,-1,0,1]}
> in audition (out 0 (rDelayMap 0 s 1 a))
