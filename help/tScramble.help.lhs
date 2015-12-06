> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.External.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary tScramble_dsc

two channel sin tones, channels scramble on impulse

> gr_01 =
>     let tr = impulse KR 1 0
>     in sinOsc AR (tScramble 'α' tr (mce2 440 880)) 0 * 0.1
