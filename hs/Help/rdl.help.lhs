> import Sound.OSC {- hosc -}
> import Sound.SC3.ID
> import Sound.SC3.UGen.External.RDU

rdl2 is a two-channel host for hdf generated DSP codes.
> let m = [b_alloc 0 48000 1,b_alloc 1 48000 1]
> let g = synthdef "rdl2" (out 0 (rdl2 0))
> let i = ugenIndices "RDL" (synthdefGraph g)
> i == [0]
> audition g
> withSC3 (sendBundle (bundle immediately m))
> withSC3 (send (u_cmd (-1) 0 "/g_load" [String "/tmp/analog-bubbles.so"]))
> withSC3 (send (u_cmd (-1) 0 "/g_load" [String "/tmp/moto-rev.so"]))
> withSC3 (send (u_cmd (-1) 0 "/g_load" [String "/tmp/sprinkler.so"]))
> withSC3 (send (u_cmd (-1) 0 "/g_load" [String "/tmp/lfo-modulation.so"]))
