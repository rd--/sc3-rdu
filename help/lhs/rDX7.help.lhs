> import Data.Word {- base -}

> import Sound.OSC {- hosc -}
> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

> import qualified Sound.SC3.Data.Yamaha.DX7 as DX7 {- hsc3-data -}

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.rDX7_dsc

> word8_to_double :: Word8 -> Double
> word8_to_double = fromIntegral

> dx7_init_f64 :: [Double]
> dx7_init_f64 = map word8_to_double DX7.dx7_init_voice

      > withSC3 (async (b_alloc 0 256 1) >> sendMessage (b_setn1 0 0 dx7_init_f64))

> g_01 = rdx7 AR 0 (control KR "gate" 0.0) 60 60
