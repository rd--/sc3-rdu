> import Sound.SC3.ID
> import Sound.SC3.UGen.External.RDU.ID

arguments
> Sound.SC3.UGen.DB.u_summary dustR_dsc

dustR generates triggers where the inter-offset times are generated
randomly in the specified range (seconds) with linear distribution.
> let {a = dustR 'α' AR 0.0001 0.001 * 0.1
>     ;b = dustR 'β' AR 0 2}
> in audition (out 0 (mce2 a b))
