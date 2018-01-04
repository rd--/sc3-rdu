> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.expRandN_dsc

two channel sin tones

> gr_01 = sinOsc AR (expRandN 2 'α' 440 880) 0 * 0.1

n node klang synthesis

> gr_02 =
>     let n = 240
>         f = expRandN n 'α' 40 18000
>         a = expRandN n 'β' 0.1 0.3
>         p = randN n 'γ' (-1) 1
>         s = klangSpec_mce f a p
>     in klang AR 1 0 s * 0.05

mce...

> gr_03 =
>     let f = randN 2 'α' (mce2 440 441) 442
>     in sinOsc AR f 0 * 0.1
