> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.External.RDU {- sc3-rdu -}

> Sound.SC3.UGen.DB.Record.u_summary tScramble_dsc

two channel sin tones, channels scramble on impulse

> let {i = impulse KR 1 0
>      ;o = sinOsc AR (tScramble 'α' KR i (mce2 440 880)) 0 * 0.1}
> in audition (out 0 o) >> Sound.SC3.UGen.Dot.draw (out 0 o)
