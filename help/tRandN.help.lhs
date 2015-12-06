> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.External.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary tRandN_dsc

> gr_01 =
>     let tr = impulse KR 1 0
>     in sinOsc AR (tRandN 2 'α' 440 880 tr) 0 * 0.1

