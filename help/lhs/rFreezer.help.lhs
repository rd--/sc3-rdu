Concurrent loops at a signal buffer

Create a set of concurrent loops at a signal buffer.  This is the
dynamic and gestural variant of RLoopSet.  It was written after
reading the manual for the GRM Tools 'Freeze' plugin.

> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}
> import qualified Sound.SC3.UGen.Record.Plain.RFreezer as R {- hsc3-rec -}

Create a set of concurrent loops at a signal buffer.

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.rFreezer_dsc

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

> gr_02 = rFreezer 10 0.35 0.4 0.6 0.1 0.05 0.02 0.1 0 0 6

> gr_03 = rFreezer 10 0.3 0.4 0.6 1 0 0 0 0 0 6

> gr_04 = rFreezer 10 0.3 0.7 0.6 0.35 0 0.5 0.5 0 0 6

> gr_05 = rFreezer 10 0.2500 0.2505 0.1 1 0 0.050 0.005 0 0 24

K-rate instances

> gr_06 =
>     let n z f i j = linLin (lfNoise2 z KR f) (-1) 1 i j
>         left = n 'α' 1 0.3 0.8
>         right = left + n 'β' 1 0.01 0.05
>     in rFreezer 10 left right 0.1 0.5 0.1 0.5 0.05 0 0 24

K-rate & record interface

> f_01 b (incr_l,incr_r) dgr =
>     let n z i j = linLin (lfNoise2 z KR 0.1) (-1) 1 i j
>         r = R.RFreezer
>             {R.rate = AR
>             ,R.bufnum = b
>             ,R.left = n 'α' 0.3 0.4
>             ,R.right = n 'β' 0.5 0.6
>             ,R.gain = n 'γ' 0.3 0.6
>             ,R.increment = n 'δ' incr_l incr_r
>             ,R.incrementOffset = n 'ε' 0.05 0.15
>             ,R.incrementRandom = n 'ζ' 0.05 0.15
>             ,R.rightRandom = n 'η' 0.05 0.15
>             ,R.syncPhaseTrigger = 0
>             ,R.randomizePhaseTrigger = 0
>             ,R.numberOfLoops = dgr}
>     in R.mkRFreezer r

> gr_07 = f_01 10 (0.05,0.15) 6

K-rate & external input

> gr_08 =
>   let bufnum = clearBuf (localBuf 'α' 1 (48000 * 2)) -- 2 4 6 8 12
>       i = recordBuf AR bufnum (2048 * 12) 1 0 1 Loop 1 DoNothing (soundIn 0 * 1.5)
>       o = f_01 bufnum (0.95,1.05) 36
>   in mrg2 o i
