> import Data.Word {- base -}

> import Sound.OSC {- hosc -}
> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

> import qualified Sound.SC3.Data.Yamaha.DX7 as DX7 {- hsc3-data -}

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.rDX7_dsc

> word8_to_double :: Word8 -> Double
> word8_to_double = fromIntegral

> dx7_data_msg :: Buffer_Id -> [Word8] -> Message
> dx7_data_msg k = b_setn1 k 0 . map word8_to_double

      > withSC3 (async (b_alloc 0 8192 1))
      > withSC3 (sendMessage (dx7_data_msg 0 DX7.dx7_init_voice))

> g_01 =
>   let gate_ = control KR "gate" 0
>       data_ = control KR "data" 0
>       vc = control KR "vc" 0
>       mnn = control KR "mnn" 60
>       vel = control KR "vel" 99
>   in rdx7 AR 0 gate_ data_ vc mnn vel

      > withSC3 (sendMessage (n_set1 (-1) "gate" 1.0))
      > withSC3 (sendMessage (n_set1 (-1) "data" 0.0))
      > withSC3 (sendMessage (n_set1 (-1) "mnn" 69.0))
      > withSC3 (sendMessage (n_set1 (-1) "vel" 10.0))

      > withSC3 (async (b_alloc 0 8192 1))
      > let syx_fn = "/home/rohan/sw/hsc3-data/data/yamaha/dx7/rom/DX7-ROM1B.syx"
      > let syx_fn = "/home/rohan/uc/the-center-is-between-us/trees/syx/tc.000.syx"
      > bnk <- DX7.dx7_load_fmt9_sysex syx_fn
      > withSC3 (sendMessage (dx7_data_msg 0 (concat bnk)))

> g_02 =
>   let tr = dust 'α' KR 2.0
>       gate_ = toggleFF tr
>       data_ = control KR "data" 0.0
>       vc = tRand 'β' 0 31 tr
>       mnn = tRand 'γ' 60 61 tr -- FRACTIONAL MIDI NOTE NUMBER
>       vel = tRand 'δ' 10 99 tr
>       loc = tRand 'ε' (-1) 1 tr
>   in pan2 (rdx7 AR 0 gate_ data_ vc mnn vel) loc 1
