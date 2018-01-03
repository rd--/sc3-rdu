> import Sound.OSC {- hosc -}
> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary rPlayTrace_dsc

UGens to read a buffer that is arranged as a trace.  A trace is a
sequence of tuples (T,X,Y,Z).

A trace that traverses a diamond in equal time increments.

> tr_01 =
>     [  0, -1, 1/4, 0
>     ,1/4,  0, 1/2, 0
>     ,1/2,  1, 1/4, 0
>     ,3/4,  0,   0, 0
>     ,  1, -1, 1/4, 0]

    withSC3 (sendMessage (b_alloc_setn1 0 0 tr_01))

The X element of the trace is [-1, 0, 1, 0, -1].

> gr_01 =
>     let o = sinOsc AR 440 0 * 0.1
>         l = rPlayTrace KR 0 4 (mouseX KR 1 20 Linear 0.1) 1
>     in pan2 o l 1

The Y element is [1/4, 1/2, 1/4, 0, 1/4].

> gr_02 =
>     let o = sinOsc AR 440 0 * 0.1
>         tr f n = rPlayTrace KR 0 4 (f KR 1 20 Linear 0.1) n
>         l = tr mouseX 1
>         g = tr mouseY 2
>     in pan2 o l g

Altering the time points (subtly...)

> tr_02 =
>     [  0, -1, 1/4, 0
>     ,1/8,  0, 1/2, 0
>     ,1/4,  1, 1/4, 0
>     ,1/2,  0,   0, 0
>     ,  1, -1, 1/4, 0]

    withSC3 (sendMessage (b_setn1 0 0 tr_02))
