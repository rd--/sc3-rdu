> import Sound.SC3.ID
> import Sound.SC3.UGen.External.RDU

> Sound.SC3.UGen.DB.u_summary randN_dsc

two channel sin tones
> let o = sinOsc AR (randN 2 'a' 440 442) 0 * 0.1
> in audition (out 0 o)

n node klang synthesis
> let {n = 240
>     ;f = randN n 'a' 40 18000
>     ;a = randN n 'b' 0.1 0.3
>     ;p = randN n 'c' (-1) 1
>     ;s = klangSpec_mce f a p}
> in audition (out 0 (klang AR 1 0 s * 0.05))

mce...
> let {f = randN 2 'a' (mce2 440 441) 442
>     ;o = sinOsc AR f 0 * 0.1}
> in audition (out 0 o) >>
> Sound.SC3.UGen.Dot.draw (out 0 o)

