A `PV` unit generator that tracks the rise of magnitudes immediately,
but decays them according to a set of multipliers given in a table.
At each frame each partial decays by the amount indicated in the table,
if the decaying value is below the input value it is reset.

> import Sound.OSC {- hsc3 -}
> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.rpvDecayTbl_dsc

allocate and fill buffers

> bf_01 sz = do
>   let sz' = sz `div` 2
>   _ <- async (b_alloc 10 sz 1)
>   _ <- async (b_alloc 11 sz' 1)
>   _ <- async (b_alloc 12 sz' 1)
>   sendMessage (b_fill 11 [(0,sz',0.75)])
>   sendMessage (b_fill 12 [(0,sz',0.0)])

    withSC3 (bf_01 2048)

pass though, sanity check

> g_00 = ifft' (fft' 10 (soundIn 0))

decay system

> g_01 = ifft' (rpvDecayTbl KR (fft' 10 (soundIn 0)) 11 12)

reset decay rate buffer

    withSC3 (sendMessage (b_fill 11 [(0,1024,0.95)]))
    withSC3 (sendMessage (b_fill 11 [(0,1024,0.05)]))
    withSC3 (sendMessage (b_fill 11 [(96,32,0.95)]))
