> import Sound.SC3
> import Sound.SC3.UGen.External.RDU

Arguments...
> Sound.SC3.UGen.DB.u_summary rShufflerL_dsc

Mouse control
> let {o = sinOsc AR (mce2 440 441) 0 * 0.2
>     ;x = mouseX KR 0.0001 0.02 Linear 0.2
>     ;y = mouseY KR 0.001 0.25 Linear 0.2}
> in audition (out 0 (rShufflerL o x y))

Arrayed...
> let {n = 6
>     ;o = sinOsc AR (mce2 440 441) 0 * (0.2 / fromIntegral n)
>     ;x = mouseX KR 0.0001 0.02 Linear 0.2
>     ;y = mouseY KR 0.001 0.25 Linear 0.2
>     ;f = x * randN n 'a' 0 4
>     ;d = y * randN n 'b' 0 4}
> in audition (out 0 (splay (rShufflerL o f d) 1 1 0 True))

... or Sound.SC3.UGen.Dot.draw
