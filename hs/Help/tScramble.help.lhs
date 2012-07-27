> import Sound.SC3.ID
> import Sound.SC3.UGen.External.RDU

> Sound.SC3.UGen.DB.u_summary tScramble_dsc

two channel sin tones, channels scramble on impulse
> let {i = impulse KR 1 0
>      ;o = sinOsc AR (tScramble 'a' KR i (mce2 440 880)) 0 * 0.1}
> in audition (out 0 o) >> Sound.SC3.UGen.Dot.draw (out 0 o)
