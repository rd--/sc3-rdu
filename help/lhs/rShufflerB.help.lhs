> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}
> import Sound.SC3.UGen.Record.Plain.RShufflerB {- hsc3-rec -}

A buffer signal shuffler.

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.rShufflerB_dsc

Allocate buffer (#10), required for all examples below.

> ld fn = withSC3 (async (b_allocRead 10 fn 0 0))

    ld "/home/rohan/data/audio/instr/crotales/crotale05(D).wav"

Check buffer.

> gr_01 =
>     let s = bufRateScale KR 10
>     in playBuf 1 AR 10 s 1 0 NoLoop RemoveSynth * 0.1

Static (record)

> gr_02 =
>     let r = RShufflerB
>             {rate = AR
>             ,bufnum = 10
>             ,readLocationMinima = 0.0
>             ,readLocationMaxima = 0.05
>             ,readIncrementMinima = 0.95
>             ,readIncrementMaxima = 1.05
>             ,durationMinima = 0.035
>             ,durationMaxima = 0.050
>             ,envelopeAmplitudeMinima = 0.1
>             ,envelopeAmplitudeMaxima = 0.2
>             ,envelopeShapeMinima = 0.5
>             ,envelopeShapeMaxima = 0.6
>             ,envelopeSkewMinima = 0.4
>             ,envelopeSkewMaxima = 0.6
>             ,stereoLocationMinima = 0
>             ,stereoLocationMaxima = 1
>             ,interOffsetTimeMinima = 0.005
>             ,interOffsetTimeMaxima = 0.010
>             ,ftableReadLocationIncrement = 1
>             ,readIncrementQuanta = 0
>             ,interOffsetTimeQuanta = 0}
>     in mkRShufflerB r

Static (parameter)

> gr_03 = rShufflerB 10 0 0.05 0.95 1.05 0.035 0.05 0.1 0.2 0.4 0.6 0.4 0.6 0 1 0.005 0.01 1 0 0

Static (static,quantized)

> gr_04 = rShufflerB 10 0 1 0.5 2 0.025 0.075 0.2 0.6 0.1 0.9 0.1 0.9 0 1 0.005 0.05 0 0.5 0.005

Static (static,pointilist)

> gr_05 = rShufflerB 10 0.4 0.5 0.5 2 0.05 0.15 0.2 0.5 0.3 0.7 0.3 0.7 0 1 0.05 0.25 0 0 0

Circulating record to buffer & static (record, use localBuf)

> gr_06 =
>     let r = RShufflerB
>             {rate = AR
>             ,bufnum = clearBuf (localBuf 'α' 1 (48000 * 4))
>             ,readLocationMinima = 0.0
>             ,readLocationMaxima = 0.05
>             ,readIncrementMinima = 1.99975
>             ,readIncrementMaxima = 2.00025
>             ,durationMinima = 0.25
>             ,durationMaxima = 0.30
>             ,envelopeAmplitudeMinima = 0.8
>             ,envelopeAmplitudeMaxima = 0.9
>             ,envelopeShapeMinima = 0.5
>             ,envelopeShapeMaxima = 0.6
>             ,envelopeSkewMinima = 0.4
>             ,envelopeSkewMaxima = 0.6
>             ,stereoLocationMinima = 0
>             ,stereoLocationMaxima = 1
>             ,interOffsetTimeMinima = 0.0500
>             ,interOffsetTimeMaxima = 0.0525
>             ,ftableReadLocationIncrement = 1
>             ,readIncrementQuanta = 0
>             ,interOffsetTimeQuanta = 0}
>         o = mkRShufflerB r
>         i = recordBuf AR (bufnum r) (2048 * 12) 1 0 1 Loop 1 DoNothing (soundIn 0)
>    in mrg2 o i

    > import Sound.SC3.UGen.DB.Record
    > putStrLn $ u_control_inputs_pp Sound.SC3.UGen.External.RDU.rShufflerB_dsc

> f_01 b =
>   let k nm def ix = control_f64 KR (Just ix) nm def
>   in rShufflerB
>      b
>      (k "readLocationMinima" 0.0 0)
>      (k "readLocationMaxima" 0.05 1)
>      (k "readIncrementMinima" 1.99975 2)
>      (k "readIncrementMaxima" 2.00025 3)
>      (k "durationMinima" 0.25 4)
>      (k "durationMaxima" 0.30 5)
>      (k "envelopeAmplitudeMinima" 0.8 6)
>      (k "envelopeAmplitudeMaxima" 0.9 7)
>      (k "envelopeShapeMinima" 0.5 8)
>      (k "envelopeShapeMaxima" 0.6 9)
>      (k "envelopeSkewMinima" 0.4 10)
>      (k "envelopeSkewMaxima" 0.6 11)
>      (k "stereoLocationMinima" 0.0 12)
>      (k "stereoLocationMaxima" 1.0 13)
>      (k "interOffsetTimeMinima" 0.0500 14)
>      (k "interOffsetTimeMaxima" 0.0525 15)
>      (k "ftableReadLocationIncrement" 1.0 16)
>      (k "readIncrementQuanta" 0.0 17)
>      (k "interOffsetTimeQuanta" 0.0 18)

> gr_07 =
>   let b = clearBuf (localBuf 'α' 1 (48000 * 4))
>       o = f_01 b
>       i = recordBuf AR b (2048 * 12) 1 0 1 Loop 1 DoNothing (soundIn 0)
>   in mrg2 o i

    import Sound.OSC {- hosc3 -}
    audition_at (1001,AddToHead,1,[]) (out 0 gr_07)
    withSC3 (sendMessage (n_mapn 1001 [(0,1,19)]))
