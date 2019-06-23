> import Sound.OSC {- hsc3 -}
> import Sound.SC3 {- hsc3 -}
> import qualified Sound.SC3.UGen.Bindings.DB.RDU as RDU {- sc3-rdu -}
> import qualified Sound.SC3.Data.Trace as T {- hsc3-data -}

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.rTraceRd_dsc

UGens to read a buffer that is arranged as a trace.  A trace is a
sequence of tuples (T,X...) where the number of data points (including
T) is given by the 'degree' input at the UGen.

A trace that traverses a diamond in equal time increments.

> t_01 =
>     [  0, -1, 1/4
>     ,1/4,  0, 1/2
>     ,1/2,  1, 1/4
>     ,3/4,  0,   0
>     ,  1, -1, 1/4]

    withSC3 (sendMessage (b_alloc_setn1 0 0 t_01))

The X element of the trace is [-1, 0, 1, 0, -1].

Printing only (no audio, see scserver console output stream)

> g_01 =
>     let t = impulse KR 5 0
>         ph = mouseX KR 0 1 Linear 0.05
>         tr = RDU.rTraceRd KR 0 3 ph 1
>         labels = mce . map label
>         pr = poll t (mce2 ph tr) 0 (labels ["ph","tr"])
>     in mrg2 (out 0 (dc AR 0)) pr

Listening:

> g_02 =
>     let o = sinOsc AR 440 0 * 0.1
>         x = RDU.rTraceRd KR 0 3 (lfSaw KR 1 0 * 0.5 + 0.5) 1
>     in pan2 o x 1

> g_03 =
>     let x = RDU.rTraceRd KR 0 3 (lfSaw KR 1 0 * 0.5 + 0.5) 1
>         o = sinOsc AR (linLin x (-1) 1 440 880) 0 * 0.1
>     in pan2 o 0 1

The Y element is [1/4, 1/2, 1/4, 0, 1/4].

> g_04 =
>     let o = sinOsc AR 440 0 * 0.1
>         tr n = RDU.rTraceRd KR 0 3 (lfSaw KR 1 0 * 0.5 + 0.5) n
>         l = tr 1
>         g = tr 2
>     in pan2 o l g

Altering the time points, while running...

> t_02 =
>     [  0, -1, 1/4
>     ,1/8,  0, 1/2
>     ,1/4,  1, 1/4
>     ,1/2,  0,   0
>     ,  1, -1, 1/4]

    withSC3 (sendMessage (b_setn1 0 0 t_02))

Loading data from a CSV trace file

> t_03 = do
>   let fn = "/home/rohan/sw/hsc3-data/data/csv/trace/b.csv"
>   tr <- T.trace_load_csv2 fn
>   let tr' = T.trace_normalise_t tr
>       d = concatMap (\(t,(x,y)) -> [t,x,y]) tr'
>   withSC3 (async (b_alloc_setn1 0 0 d) >> return ())

    t_03
    withSC3 (b_query1_unpack 0)
