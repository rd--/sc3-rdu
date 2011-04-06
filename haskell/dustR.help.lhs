dustR rate lo hi

dustR generates triggers where the inter-offset times are generated
randomly in the specified range (seconds) with linear distribution.

> import Sound.SC3

> let { dustR z rt lo hi = mkOscId z rt "DustR" [lo,hi] 1
>     ; a = dustR 'a' AR 0.0001 0.001 * 0.1
>     ; b = dustR 'b' AR 0 2 }
> in audition (out 0 (mce2 a b))
