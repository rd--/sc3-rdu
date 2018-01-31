> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.rLagC_dsc

> g_01 =
>   let x = mouseX KR 220 440 Linear 0.2
>   in sinOsc AR (mce2 x (rLagC x 1 0 5 0)) 0 * 0.1

> g_02 =
>   let p = range 220 440 (lfPulse KR 0.1 0 0.5)
>       x = mouseX KR (-8) 8 Linear 0.2
>       y = mouseY KR (-8) 8 Linear 0.2
>   in sinOsc AR (mce2 p (rLagC p 0.75 x 1.5 y)) 0 * 0.1

> g_03 =
>   let o = lfPulse AR 50 0 0.25
>   in mce2 o (rLagC o (1/500) 0 (1/500) 0) * 0.2

> g_04 =
>   let o = lfPulse AR 50 0 0.25
>       x = mouseX KR 0.0 (1/100) Linear 0.2
>       y = mouseY KR 0.0 (3/100) Linear 0.2
>   in mce2 o (rLagC o x 0 y 0) * 0.2

> g_05 =
>   let o = sinOsc AR 50 0
>   in mce2 o (rLagC o 0.01 0 0.01 0) * 0.2
