> import Sound.OSC {- hosc -}
> import Sound.SC3.ID {- hsc3 -}
> import Sound.SC3.UGen.External.RDU {- sc3-rdu -}
> import Sound.DF.Uniform.Audition.SC3 {- hdf -}

`rdl` is a host for [hdf][hdf] generated DSP codes.

> Sound.SC3.UGen.DB.u_summary rdl_dsc == "RDL [AR] inputs=0.0"

`rdl` codes can read buffers and contol signals.  Required resources
must be correctly pre-allocated.

> let m = [b_alloc 0 48000 1,b_alloc 1 48000 1]
> in withSC3 (sendBundle (bundle immediately m))

`rdl` nodes are instantiated with a fixed number of channels, it is an
error to load incompatible codes.

> let g = synthdef "rdl2" (out 0 (rdl 2 (mce2 0 0)))

Codes are loaded using `u_cmd`, which requires the `ugenIndex` of the
`rdl` node.

> ugenIndices "RDL" (synthdefGraph g) == [0]

When created, the node has no code loaded.

> audition g

`hdf` includes a `g_load` function.  Codes can be replaced while the
`rdl` node is running.

> withSC3 (send (g_load (-1) 0 "/tmp/analog-bubbles.so"))
> withSC3 (send (g_load (-1) 0 "/tmp/moto-rev.so"))
> withSC3 (send (g_load (-1) 0 "/tmp/sprinkler.so"))
> withSC3 (send (g_load (-1) 0 "/tmp/lfo-modulation.so"))

[hdf]: ?t=hdf
