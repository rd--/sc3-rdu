> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.External.RDU {- sc3-rdu -}

Create a set of concurrent loops at a signal buffer.

> Sound.SC3.UGen.DB.Record.u_summary rFreezer_dsc

Allocate buffer (#10), required for all examples below.

> let fn = "/home/rohan/data/audio/instr/crotales/crotale05(D).wav"
> in withSC3 (async (b_allocRead 10 fn 0 0))

Check buffer.

> let s = bufRateScale KR 10
> in audition (out 0 (playBuf 1 AR 10 s 1 0 NoLoop RemoveSynth * 0.1))

Static instances

> let o = rFreezer 10 0.35 0.4 0.6 0.1 0.05 0.02 0.1 0 0 6
> in audition (out 0 o)

> let o = rFreezer 10 0.3 0.4 0.6 1 0 0 0 0 0 6
> in audition (out 0 o)

> let o = rFreezer 10 0.3 0.7 0.6 0.35 0 0.5 0.5 0 0 6
> in audition (out 0 o)

> let o = rFreezer 10 0.2500 0.2505 0.1 1 0 0.050 0.005 0 0 24
> in audition (out 0 o)

K-rate instances

> let {n z f i j = linLin (lfNoise2 z KR f) (-1) 1 i j
>     ;left = n 'α' 1 0.3 0.8
>     ;right = left + n 'β' 1 0.01 0.05
>     ;o = rFreezer 10 left right 0.1 0.5 0.1 0.5 0.05 0 0 24}
> in audition (out 0 o)

> let {n z i j = linLin (lfNoise2 z KR 0.1) (-1) 1 i j
>     ;left = n 'α' 0.3 0.4
>     ;right = n 'β' 0.5 0.6
>     ;gain = n 'γ' 0.3 0.6
>     ;incr = n 'δ' 0.05 0.15
>     ;incrOff = n 'ε' 0.05 0.15
>     ;incrRand = n 'ζ' 0.05 0.15
>     ;rightRand = n 'η' 0.05 0.15
>     ;o = rFreezer 10 left right gain incr incrOff incrRand rightRand 0 0 6}
> in audition (out 0 o)
