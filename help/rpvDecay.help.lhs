> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.External.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary rpvDecay_dsc

> rpvDecay :: UGen -> UGen -> UGen -> UGen
> rpvDecay b_fft b_dcy b_hst = mkUGen Nothing [KR] (Left KR) "RPVDecay" [b_fft,b_dcy,b_hst] Nothing 1 (Special 0) NoId

    withSC3 (async (b_alloc 10 2048 1))
    withSC3 (async (b_alloc 11 1024 1))
    withSC3 (async (b_alloc 12 1024 1))

    withSC3 (send (b_fill 11 [(0,1024,0.75)]))
    withSC3 (send (b_fill 12 [(0,1024,0.0)]))

> gr_00 = ifft' (fft' 10 (soundIn 0))

> gr_01 = ifft' (rpvDecay (fft' 10 (soundIn 0)) 11 12)
