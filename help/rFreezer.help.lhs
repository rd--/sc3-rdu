> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}
> import Sound.SC3.UGen.Record.Plain.RFreezer {- hsc3-rec -}

Create a set of concurrent loops at a signal buffer.

    Sound.SC3.UGen.DB.Record.u_summary rFreezer_dsc

Allocate buffer (#10), required for all examples below.

> ld fn = withSC3 (async (b_allocRead 10 fn 0 0))

    ld "/home/rohan/data/audio/instr/crotales/crotale05(D).wav"
    ld "/home/rohan/uc/sp-id/flac/gamelan/suhirdjan/nrm/saron-panerus-S-0-5.flac"
    ld "/home/rohan/uc/sp-id/flac/gamelan/suhirdjan/nrm/saron-panerus-S-0-6.flac"
    ld "/home/rohan/uc/sp-id/flac/gamelan/suhirdjan/nrm/saron-barung-S-0-1.flac"
    ld "/home/rohan/uc/sp-id/flac/gamelan/suhirdjan/nrm/saron-demung-S-1-3.flac"
    ld "/home/rohan/uc/sp-id/flac/gamelan/suhirdjan/nrm/saron-demung-S-1-5.flac"
    ld "/home/rohan/uc/sp-id/flac/gamelan/suhirdjan/nrm/saron-demung-S-1-6.flac"
    ld "/home/rohan/uc/sp-id/flac/gamelan/suhirdjan/nrm/bonang-barung-S-0-2.flac"
    ld "/home/rohan/uc/sp-id/flac/gamelan/suhirdjan/nrm/bonang-barung-S-2-1.flac"
    ld "/home/rohan/uc/sp-id/flac/gamelan/suhirdjan/gender-barung-S-1-2.flac"
    ld "/home/rohan/uc/sp-id/flac/gamelan/suhirdjan/gender-barung-S-2-5.flac"
    ld "/home/rohan/uc/sp-id/flac/gamelan/suhirdjan/gender-barung-S-3-3.flac"

Check buffer.

> gr_01 =
>     let s = bufRateScale KR 10
>     in playBuf 1 AR 10 s 1 0 NoLoop RemoveSynth * 0.1

Static instances

> gr_02 = rFreezer AR 10 0.35 0.4 0.6 0.1 0.05 0.02 0.1 0 0 6

> gr_03 = rFreezer AR 10 0.3 0.4 0.6 1 0 0 0 0 0 6

> gr_04 = rFreezer AR 10 0.3 0.7 0.6 0.35 0 0.5 0.5 0 0 6

> gr_05 = rFreezer AR 10 0.2500 0.2505 0.1 1 0 0.050 0.005 0 0 24

K-rate instances

> gr_06 =
>     let n z f i j = linLin (lfNoise2 z KR f) (-1) 1 i j
>         left = n 'α' 1 0.3 0.8
>         right = left + n 'β' 1 0.01 0.05
>     in rFreezer AR 10 left right 0.1 0.5 0.1 0.5 0.05 0 0 24

K-rate & record interface

> gr_07 =
>     let n z i j = linLin (lfNoise2 z KR 0.1) (-1) 1 i j
>         r = RFreezer {rate = AR
>                      ,bufnum = 10
>                      ,left = n 'α' 0.3 0.4
>                      ,right = n 'β' 0.5 0.6
>                      ,gain = n 'γ' 0.3 0.6
>                      ,increment = n 'δ' 0.05 0.15
>                      ,incrementOffset = n 'ε' 0.05 0.15
>                      ,incrementRandom = n 'ζ' 0.05 0.15
>                      ,rightRandom = n 'η' 0.05 0.15
>                      ,syncPhaseTrigger = 0
>                      ,randomizePhaseTrigger = 0
>                      ,numberOfLoops = 6}
>     in mkRFreezer r

    audition (out 0 (soundIn 0))
