> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.rBezier_dsc

reference sine tone

> gr_00 = sinOsc AR 440 0 * 0.25

bezier approximation of sin function

> gr_01 = rBezier AR 440 0 (mce [0,0,0.2,-1.3,0.3,-1.3,0.5,0,0.7,1.3,0.8,1.3,1,0]) * 0.1

    import Sound.SC3.Plot {- hsc3-plot -}
    ugen_render_nrt 120 gr_01
    plot_ugen1 0.01 gr_01

> gr_02 =
>     let x = mouseX KR 40 4000 Exponential 0.2
>     in rBezier AR x 0 (mce [0,0,0.2,-1.3,0.3,-1.3,0.5,0,0.7,1.3,0.8,1.3,1,0]) * 0.1

> gr_03 =
>     let x = mouseX KR 40 4000 Exponential 0.2
>         y = mouseY KR 0.1 0.2 Linear 0.2
>     in rBezier AR x 0 (mce [0,0,y,-1.3,0.3,-1.3,0.5,0,0.7,1.3,0.8,1.3,1,0]) * 0.1

dynamic shifting of control points

> f_01 rt (f0,f1) f2 =
>     let w z l r = range l r (lfdNoise3 z rt f2)
>     in rBezier rt (w 'α' f0 f1) 0 (mce [0,0,w 'β' 0.05 0.25,-1.3,w 'γ' 0.25 0.45,-1.3
>                                        ,0.5,0,w 'δ' 0.55 0.75,1.3,w 'ε' 0.75 0.95,1.3
>                                        ,1,0])

as oscillator

> g_04 = pan2 (f_01 AR (200,205) 2) (iRand 'α' (-1) 1) 0.1

as amplitude modulator

> g_05 = soundIn 0 * range 0.25 1 (f_01 KR (0.15,16) 0.5)

see hcg-minus:Data.CG.Minus.Bezier for rendering bezier curves as wavetable
