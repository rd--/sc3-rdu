> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

reference sine tone

> gr_00 = sinOsc AR 440 0 * 0.25

> gr_01 = rBezier AR 440 0 (mce [0,0,0.2,-1.3,0.3,-1.3,0.5,0,0.7,1.3,0.8,1.3,1,0]) * 0.1

> gr_02 =
>     let x = mouseX KR 40 4000 Exponential 0.2
>     in rBezier AR x 0 (mce [0,0,0.2,-1.3,0.3,-1.3,0.5,0,0.7,1.3,0.8,1.3,1,0]) * 0.1

> gr_03 =
>     let x = mouseX KR 40 4000 Exponential 0.2
>         y = mouseY KR 0.1 0.2 Linear 0.2
>     in rBezier AR x 0 (mce [0,0,y,-1.3,0.3,-1.3,0.5,0,0.7,1.3,0.8,1.3,1,0]) * 0.1

dynamic shifting of control points

> gr_04 =
>     let w z l r = range l r (lfdNoise3 z KR 1)
>     in rBezier AR (w 'α' 200 205) 0 (mce [0,0,w 'β' 0.1 0.2,-1.3,w 'γ' 0.3 0.4,-1.3
>                                          ,0.5,0,w 'δ' 0.6 0.7,1.3,w 'ε' 0.8 0.9,1.3
>                                          ,1,0]) * 0.1

    import Sound.SC3.Plot {- hsc3-plot -}
    ugen_render_nrt 120 gr_01
    plot_ugen1 0.1 gr_01

see hsc3-data/Data.CG.Minus.Bezier for rendering bezier curves as wavetable
