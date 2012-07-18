> import Sound.SC3
> import Sound.SC3.UGen.External.RDU

arguments
> Sound.SC3.UGen.DB.u_summary rTraceRd_dsc

UGens to read a buffer that is arranged as a trace.  A trace is a
sequence of tuples (T,X...) where the number of data points is given
by the 'degree' input at the UGen.

A trace that traverses a diamond in equal time increments.
> let t = [  0, -1, 1/4, 0
>         ,1/4,  0, 1/2, 0
>         ,1/2,  1, 1/4, 0
>         ,3/4,  0,   0, 0
>         ,  1, -1, 1/4, 0]

> withSC3 (\fd -> do send fd (b_alloc_setn1 0 0 t))

The X element of the trace is [-1, 0, 1, 0, -1].
> let {o = sinOsc AR 440 0 * 0.1
>     ;x = rTraceRd KR 0 4 (lfSaw KR 1 0 * 0.5 + 0.5) 1}
> in audition (out 0 (pan2 o x 1))

> let {x = rTraceRd KR 0 4 (lfSaw KR 1 0 * 0.5 + 0.5) 1
>     ;o = sinOsc AR (linLin x (-1) 1 440 880) 0 * 0.1}
> in audition (out 0 (pan2 o 0 1))

The Y element is [1/4, 1/2, 1/4, 0, 1/4].
> let {o = sinOsc AR 440 0 * 0.1
>     ;tr n = rTraceRd KR 0 4 (lfSaw KR 1 0 * 0.5 + 0.5) n
>     ;l = tr 1
>     ;g = tr 2}
> in audition (out 0 (pan2 o l g))

Altering the time points...
> let t' = [  0, -1, 1/4, 0
>          ,1/8,  0, 1/2, 0
>          ,1/4,  1, 1/4, 0
>          ,1/2,  0,   0, 0
>          ,  1, -1, 1/4, 0]

> withSC3 (\fd -> send fd (b_setn1 0 0 t'))
