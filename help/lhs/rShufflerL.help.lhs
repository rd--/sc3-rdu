> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.rShufflerL_dsc

Mouse control

> f_01 o =
>     let x = mouseX KR 0.0001 0.02 Linear 0.2
>         y = mouseY KR 0.001 0.25 Linear 0.2
>     in rShufflerL o x y

> gr_01 = f_01 (sinOsc AR (mce2 440 441) 0 * 0.2)
> gr_02 = f_01 (soundIn (mce2 0 1))

Arrayed...

> f_02 n o =
>     let n = 6
>         x = mouseX KR 0.0001 0.02 Linear 0.2
>         y = mouseY KR 0.001 0.25 Linear 0.2
>         f = x * randN n 'α' 0 4
>         d = y * randN n 'β' 0 4
>     in splay (rShufflerL o f d) 1 1 0 True

> gr_03 = f_02 6 (sinOsc AR (mce2 440 441) 0 * (0.2 / 6))
> gr_04 = f_02 6 (soundIn (mce2 0 1))

... or Sound.SC3.UGen.Dot.draw
