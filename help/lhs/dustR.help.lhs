Generates triggers where the inter-offset times are generated randomly
in the specified range (seconds) with linear distribution.

> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.dustR_dsc

a is audio rate noise, b is an impulse train

> gr_01 =
>     let a = dustR 'α' AR 0.0001 0.001 * 0.1
>         b = dustR 'β' AR 0 2
>     in mce2 a b

