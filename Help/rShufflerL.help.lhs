> import Sound.SC3
> import Sound.SC3.UGen.External.RDU

Arguments...
> rShufflerL_dsc

Mouse control
> let {o = sinOsc AR (mce2 440 441) 0 * 0.2
>     ;x = mouseX KR 0.0001 0.02 Linear 0.2
>     ;y = mouseY KR 0.001 0.25 Linear 0.2}
> in audition (out 0 (rShufflerL o x y))
