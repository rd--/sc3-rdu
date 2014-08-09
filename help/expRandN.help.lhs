> import Sound.SC3.ID
> import Sound.SC3.UGen.External.RDU
> import Sound.SC3.UGen.External.RDU.ID

> Sound.SC3.UGen.DB.u_summary expRandN_dsc

two channel sin tones

> let o = sinOsc AR (expRandN 2 'α' 440 880) 0 * 0.1
> in audition (out 0 o)

n node klang synthesis

> let {n = 240
>     ;f = expRandN n 'α' 40 18000
>     ;a = expRandN n 'β' 0.1 0.3
>     ;p = randN n 'γ' (-1) 1
>     ;s = klangSpec_mce f a p}
> in audition (out 0 (klang AR 1 0 s * 0.05))

mce...

> let {f = randN 2 'α' (mce2 440 441) 442
>     ;o = sinOsc AR f 0 * 0.1}
> in audition (out 0 o) >>
> Sound.SC3.UGen.Dot.draw (out 0 o)