> import Sound.OSC {- hsc3 -}
> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary rpvDecayTbl_dsc

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

> gr_00 = ifft' (fft' 10 (soundIn 0))

decay system

> gr_01 = ifft' (rpvDecayTbl (fft' 10 (soundIn 0)) 11 12)

reset decay rate buffer

    withSC3 (send (b_fill 11 [(0,1024,0.05)]))
    withSC3 (send (b_fill 11 [(96,32,0.95)]))
