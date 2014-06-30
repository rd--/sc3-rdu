> import Sound.SC3.ID
> import Sound.SC3.UGen.External.RDU.ID

> Sound.SC3.UGen.DB.u_summary dustR_dsc

a is audio rate noise, b is an impulse train

> let {a = dustR 'α' AR 0.0001 0.001 * 0.1
>     ;b = dustR 'β' AR 0 2}
> in audition (out 0 (mce2 a b))
