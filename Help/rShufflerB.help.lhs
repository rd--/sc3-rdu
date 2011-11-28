> import Sound.SC3
> import Sound.SC3.UGen.External.RDU

A buffer signal shuffler.
> rShufflerB_dsc
> :i RShufflerB

Allocate buffer, required for all examples below.
> let fn = "/home/rohan/data/audio/material/crotales/crotale05(D).wav"
> in withSC3 (\fd -> async fd (b_allocRead 10 fn 0 0))

Check buffer.
> let s = bufRateScale KR 10
> in audition (out 0 (playBuf 1 AR 10 s 1 0 NoLoop RemoveSynth * 0.1))

Static (record)
> let {r = RShufflerB {bufnum = 10
>                     ,readLocationMinima = 0.0
>                     ,readLocationMaxima = 0.05
>                     ,readIncrementMinima = 0.95
>                     ,readIncrementMaxima = 1.05
>                     ,durationMinima = 0.035
>                     ,durationMaxima = 0.050
>                     ,envelopeAmplitudeMinima = 0.1
>                     ,envelopeAmplitudeMaxima = 0.2
>                     ,envelopeShapeMinima = 0.5
>                     ,envelopeShapeMaxima = 0.6
>                     ,envelopeSkewMinima = 0.4
>                     ,envelopeSkewMaxima = 0.6
>                     ,stereoLocationMinima = 0
>                     ,stereoLocationMaxima = 1
>                     ,interOffsetTimeMinima = 0.005
>                     ,interOffsetTimeMaxima = 0.010
>                     ,ftableReadLocationIncrement = 1
>                     ,readIncrementQuanta = 0
>                     ,interOffsetTimeQuanta = 0}
>     ;o = rShufflerB_r r}
> in audition (out 0 o)

Static (parameter)
> let o = rShufflerB 10 0 0.05 0.95 1.05 0.035 0.050 0.1 0.2 0.4 0.6 0.4 0.6 0 1 0.005 0.010 1 0 0
> in audition (out 0 o)

Static (static,quantized)
> let o = rShufflerB 10 0 1 0.5 2 0.025 0.075 0.2 0.6 0.1 0.9 0.1 0.9 0 1 0.005 0.050 0 0.5 0.005
> in audition (out 0 o)

Static (static,pointilist)
> let o = rShufflerB 10 0.4 0.5 0.5 2 0.05 0.15 0.2 0.5 0.3 0.7 0.3 0.7 0 1 0.05 0.25 0 0 0
> in audition (out 0 o)
