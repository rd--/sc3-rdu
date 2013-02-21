> import Sound.OSC {- hosc -}
> import Sound.SC3.ID
> import Sound.SC3.UGen.External.RDU

rdf2 is a two-channel host for hdf generated DSP codes.
> let g = synthdef "rdf2" (out 0 (rdf2 0))
> let i = ugenIndices "RDF" (synthdefGraph g)
> audition g
> withSC3 (send (u_cmd (-1) 0 "g_load" [String "/home/rohan/tmp/analog-bubbles.so"]))