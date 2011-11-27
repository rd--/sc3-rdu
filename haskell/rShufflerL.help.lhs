rShufflerL in fragmentSize maxDelay

> import Sound.SC3

Define UGen
> let rShufflerL i fs md = mkFilterR [AR] "RShufflerL" [i,fs,md] 1

> let {o = sinOsc AR (mce2 440 441) 0 * 0.2
>     ;x = mouseX' KR 0.0001 0.02 Linear 0.2
>     ;y = mouseY' KR 0.001 0.25 Linear 0.2}
> in audition (out 0 (rShufflerL o x y))
