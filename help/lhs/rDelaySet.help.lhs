> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary rDelaySet_dsc

Three one second delays...

> gr_01 =
>     let x = mouseX KR 110 660 Linear 0.2
>         y = mouseY KR 0 0.2 Linear 0.2
>         s = sinOsc AR x 0 * y
>         d = rDelaySet s (mce [1,1,1/5,2,1/2,1/10,3,1/3,1/15])
>     in mce2 s d
