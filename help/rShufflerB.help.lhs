> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.External.RDU as R {- sc3-rdu -}

A buffer signal shuffler.

> Sound.SC3.UGen.DB.u_summary R.rShufflerB_dsc
> :i R.RShufflerB

Allocate buffer (#10), required for all examples below.

> let fn = "/home/rohan/data/audio/instr/crotales/crotale05(D).wav"
> in withSC3 (async (b_allocRead 10 fn 0 0))

Check buffer.

> let s = bufRateScale KR 10
> in audition (out 0 (playBuf 1 AR 10 s 1 0 NoLoop RemoveSynth * 0.1))

Static (record)

> let {r = RShufflerB
>      {bufnum = 10
>      ,readLocationMinima = 0.0
>      ,readLocationMaxima = 0.05
>      ,readIncrementMinima = 0.95
>      ,readIncrementMaxima = 1.05
>      ,durationMinima = 0.035
>      ,durationMaxima = 0.050
>      ,envelopeAmplitudeMinima = 0.1
>      ,envelopeAmplitudeMaxima = 0.2
>      ,envelopeShapeMinima = 0.5
>      ,envelopeShapeMaxima = 0.6
>      ,envelopeSkewMinima = 0.4
>      ,envelopeSkewMaxima = 0.6
>      ,stereoLocationMinima = 0
>      ,stereoLocationMaxima = 1
>      ,interOffsetTimeMinima = 0.005
>      ,interOffsetTimeMaxima = 0.010
>      ,ftableReadLocationIncrement = 1
>      ,readIncrementQuanta = 0
>      ,interOffsetTimeQuanta = 0}
>     ;o = rShufflerB_r r}
> in audition (out 0 o)

Static (parameter)

> let o = rShufflerB 10 0 0.05 0.95 1.05 0.035 0.05 0.1 0.2 0.4 0.6 0.4 0.6 0 1 0.005 0.01 1 0 0
> in audition (out 0 o)

Static (static,quantized)

> let o = rShufflerB 10 0 1 0.5 2 0.025 0.075 0.2 0.6 0.1 0.9 0.1 0.9 0 1 0.005 0.05 0 0.5 0.005
> in audition (out 0 o)

Static (static,pointilist)

> let o = rShufflerB 10 0.4 0.5 0.5 2 0.05 0.15 0.2 0.5 0.3 0.7 0.3 0.7 0 1 0.05 0.25 0 0 0
> in audition (out 0 o)

Circulating record to buffer & static (record, use localBuf)

> let {r = RShufflerB
>      {bufnum = clearBuf (localBuf 'a' 1 (48000 * 4))
>      ,readLocationMinima = 0.0
>      ,readLocationMaxima = 0.05
>      ,readIncrementMinima = 1.99975
>      ,readIncrementMaxima = 2.00025
>      ,durationMinima = 0.25
>      ,durationMaxima = 0.30
>      ,envelopeAmplitudeMinima = 0.8
>      ,envelopeAmplitudeMaxima = 0.9
>      ,envelopeShapeMinima = 0.5
>      ,envelopeShapeMaxima = 0.6
>      ,envelopeSkewMinima = 0.4
>      ,envelopeSkewMaxima = 0.6
>      ,stereoLocationMinima = 0
>      ,stereoLocationMaxima = 1
>      ,interOffsetTimeMinima = 0.0500
>      ,interOffsetTimeMaxima = 0.0525
>      ,ftableReadLocationIncrement = 1
>      ,readIncrementQuanta = 0
>      ,interOffsetTimeQuanta = 0}
>     ;o = rShufflerB_r r
>     ;i = recordBuf AR (bufnum r) (2048 * 12) 1 0 1 Loop 1 DoNothing (soundIn 0)}
> in audition (out 0 (mrg2 o i))
