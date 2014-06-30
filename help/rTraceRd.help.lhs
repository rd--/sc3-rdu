> Sound.SC3.UGen.DB.u_summary rTraceRd_dsc

> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.External.RDU {- sc3-rdu -}

UGens to read a buffer that is arranged as a trace.  A trace is a
sequence of tuples (T,X...) where the number of data points is given
by the 'degree' input at the UGen.

A trace that traverses a diamond in equal time increments.

> let t = [  0, -1, 1/4
>         ,1/4,  0, 1/2
>         ,1/2,  1, 1/4
>         ,3/4,  0,   0
>         ,  1, -1, 1/4]

> withSC3 (send (b_alloc_setn1 0 0 t))

The X element of the trace is [-1, 0, 1, 0, -1].

Printing:

> let {t = impulse KR 5 0
>     ;ph = mouseX KR 0 1 Linear 0.05
>     ;tr = rTraceRd KR 0 3 ph 1
>     ;labels = mce . map label
>     ;pr = poll t (mce2 ph tr) (labels ["ph","tr"]) 0}
> in audition (mrg [out 0 (dc AR 0),pr])

Listening:

> let {o = sinOsc AR 440 0 * 0.1
>     ;x = rTraceRd KR 0 3 (lfSaw KR 1 0 * 0.5 + 0.5) 1}
> in audition (out 0 (pan2 o x 1))

> let {x = rTraceRd KR 0 3 (lfSaw KR 1 0 * 0.5 + 0.5) 1
>     ;o = sinOsc AR (linLin x (-1) 1 440 880) 0 * 0.1}
> in audition (out 0 (pan2 o 0 1))

The Y element is [1/4, 1/2, 1/4, 0, 1/4].

> let {o = sinOsc AR 440 0 * 0.1
>     ;tr n = rTraceRd KR 0 3 (lfSaw KR 1 0 * 0.5 + 0.5) n
>     ;l = tr 1
>     ;g = tr 2}
> in audition (out 0 (pan2 o l g))

Altering the time points...

> let t' = [  0, -1, 1/4, 0
>          ,1/8,  0, 1/2, 0
>          ,1/4,  1, 1/4, 0
>          ,1/2,  0,   0, 0
>          ,  1, -1, 1/4, 0]

> withSC3 (send (b_setn1 0 0 t'))

Loading from a binary trace file stored in an audio file.

> import Sound.SC3.Data.Trace {- hsc3-data -}

> t <- trace_load_sf2 "/home/rohan/sw/hsc3-data/help/au/t0.txy.au"
> let d = concatMap (\(t,(x,y)) -> [t,x,y]) t
> withSC3 (async (b_alloc_setn1 0 0 d))

