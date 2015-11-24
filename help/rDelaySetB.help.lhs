> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.External.RDU as R {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary R.rDelaySetB_dsc

Three one second delays...

> gr_01 =
>     let x = mouseX KR 110 660 Linear 0.2
>         y = mouseY KR 0 0.6 Linear 0.2
>         s = sinOsc AR x 0 * y
>         b = clearBuf (localBuf 'α' 1 (5 * 44100))
>         d = rDelaySetB b s (mce [1,1,1/5,2,1/2,1/10,3,1/3,1/15])
>     in mce2 s d
