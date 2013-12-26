> import Sound.SC3.ID
> import Sound.SC3.UGen.External.RDU

> Sound.SC3.UGen.DB.u_summary rDelaySet_dsc

Three one second delays...

> let {x = mouseX KR 110 660 Linear 0.2
>     ;y = mouseY KR 0 0.6 Linear 0.2
>     ;s = sinOsc AR x 0 * y
>     ;d = rDelaySet s (mce [1,1,1/5,2,1/2,1/10,3,1/3,1/15])}
> in audition (out 0 (mce2 s d))
