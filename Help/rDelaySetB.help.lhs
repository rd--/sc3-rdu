> import Sound.SC3.ID
> import Sound.SC3.UGen.External.RDU

Arguments...
> rDelaySetB_dsc

Allocate buffer
> withSC3 (\fd -> async fd (b_alloc 10 (5 * 44100) 1))

Three one second delays...
> let {x = mouseX KR 110 660 Linear 0.2
>     ;y = mouseY KR 0 0.6 Linear 0.2
>     ;s = sinOsc AR x 0 * y
>     ;d = rDelaySetB 10 s (mce [1,1,1/5,2,1/2,1/10,3,1/3,1/15])}
> in audition (out 0 (mce2 s d))
