> import Sound.SC3
> import Sound.SC3.UGen.External.RDU

    audition (out 0 (spl1 (1024 * 2) (-) (soundIn 0)))
    audition (out 0 (spl1 (1024 * 16) (+) (soundIn 0)))

> spl1 sz op z =
>     let c0 = fft' (localBuf 'α' sz 1) z
>         (c1,c2) = pv_Split' c0 (localBuf 'β' sz 1)
>     in ifft' c1 `op` ifft' c2

    audition (out 0 (spl2 (1024 * 16)))

> spl2 sz =
>     let z = lfClipNoise 'α' AR 100 * 0.1
>     in spl1 sz (-) z

`pv_splita` is a variant, like `ffta`, that allocates a local buffer.
It tracks down the buffer size from the input graph.

    audition (out 0 spl3)

> spl3 =
>     let s = whiteNoise 'α' AR * 0.1
>         c1 = ffta 'β' 2048 s 0.5 0 1 0
>         (c2,c3) = pv_splita 'γ' c1
>         c4 = pv_BrickWall c2 (-0.85)
>         c5 = pv_BrickWall c3 0.45
>     in ifft c4 0 0 * 0.15 + ifft c5 0 0

It works with external buffers as well.

    withSC3 (async (b_alloc 10 1024 1))
    audition (out 0 (spl4 10 (soundIn 0)))

> spl4 b z =
>     let c1 = fft b z 0.5 0 1 0
>         (c2,c3) = pv_splita 'γ' c1
>         c4 = pv_BrickWall c2 (-0.85)
>         c5 = pv_BrickWall c3 0.45
>     in ifft c4 0 0 * 0.15 + ifft c5 0 0

Leaving out `pv_split` gives an invalid graph

    audition (out 0 spl5)

> spl5 =
>     let s = whiteNoise 'α' AR * 0.1
>         c1 = ffta 'β' 2048 s 0.5 0 1 0
>         c4 = pv_BrickWall c1 (-0.85)
>         c5 = pv_BrickWall c1 0.45
>     in ifft c4 0 0 * 0.15 + ifft c5 0 0
