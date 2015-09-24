> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.External.RDU {- sc3-rdu -}

> Sound.SC3.UGen.DB.Record.u_summary dustR_dsc

a is audio rate noise, b is an impulse train

> let {a = dustR 'α' AR 0.0001 0.001 * 0.1
>     ;b = dustR 'β' AR 0 2}
> in audition (out 0 (mce2 a b))
