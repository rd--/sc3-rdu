> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.tRandN_dsc

n sine tones, set to linear-random frequencies on trigger

> f_01 n =
>     let tr = impulse KR 1 0
>     in splay (sinOsc AR (tRandN n 'α' 440 880 tr) 0) 1 0.1 0 True

> gr_01 = f_01 12
