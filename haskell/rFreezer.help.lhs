rFreezer bufnum left right gain increment
         incrementOffset incrementRandom rightRandom
         syncPhaseTrigger randomizePhaseTrigger
         numberOfLoops

Create a set of concurrent loops at a signal buffer.

> import Sound.SC3.ID

Allocate buffer, required for all examples below.
> let fn = "/home/rohan/data/audio/material/crotales/crotale05(D).wav"
> in withSC3 (\fd -> async fd (b_allocRead 10 fn 0 0))

Check buffer.
> let s = bufRateScale KR 10
> in audition (out 0 (playBuf 1 AR 10 s 1 0 NoLoop RemoveSynth))

Define UGen.
> let rFreezer b l r g i io ir rr ps pt nl = mkOsc AR "RFreezer" [b,l,r,g,i,io,ir,rr,ps,pt,nl] 1

Static instances
> let o = rFreezer 10 0.35 0.4 0.6 0.1 0.05 0.02 0.1 0 0 6
> in audition (out 0 o)

> let o = rFreezer 10 0.3 0.4 0.6 1 0 0 0 0 0 6
> in audition (out 0 o)

> let o = rFreezer 10 0.3 0.7 0.6 0.35 0 0.5 0.5 0 0 6
> in audition (out 0 o)

> let o = rFreezer 10 0.15 0.85 0.3 0.35 0.15 0.05 0.34 0 0 24
> in audition (out 0 o)

K-rate instance
> let {bufnum = 10
>     ;n z i j = linLin (lfNoise2 z KR 0.1) (-1) 1 i j
>     ;left = n 'a' 0.3 0.4
>     ;right = n 'b' 0.5 0.6
>     ;gain = n 'c' 0.3 0.6
>     ;increment = n 'd' 0.05 0.15
>     ;incrementOffset = n 'e' 0.05 0.15
>     ;incrementRandom = n 'f' 0.05 0.15
>     ;rightRandom = n 'g' 0.05 0.15
>     ;o = rFreezer 10 left right gain increment incrementOffset incrementRandom rightRandom 0 0 6}
> in audition (out 0 o)
