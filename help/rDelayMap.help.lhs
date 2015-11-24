> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.External.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary rDelayMap_dsc

Simple delay (static)

> gr_01 =
>     let a = mce [-1,0,0,0.5,1,-1,0,1]
>         b = clearBuf (localBuf 'α' 1 88200)
>         x = mouseX KR 110 440 Linear 0.1
>         y = mouseY KR 0.0 0.2 Linear 0.1
>         o = sinOsc AR x 0 * y
>     in mce [rDelayMap b o 0 a,o]

Simple feedback circuit (static)

> gr_02 =
>     let n = whiteNoise 'α' AR
>         b = clearBuf (localBuf 'β' 1 88200)
>         s = decay (impulse AR (5/4) 0) 0.1 * n * 0.2
>         a = mce [-1,0,0,1,1/9,0,1,8/9,1,-1,0,1]
>     in rDelayMap b s 0 a

Simple feedback circuit (dynamic)

> gr_03 =
>     let n = whiteNoise 'α' AR
>         s = decay (impulse AR (mce [1/3,5/4]) 0) 0.1 * n * 0.2
>         x = mouseX KR 0.05 1.05 Linear 0.1
>         y = mouseY KR 0.05 0.95 Linear 0.1
>         a = mce [-1,0,0,1,y,0,1,x,1,-1,0,1]
>         b = clearBuf (localBuf 'β' 1 88200)
>     in rDelayMap b s 1 a
