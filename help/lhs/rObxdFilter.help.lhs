> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.rObxdFilter_dsc

cutoff    : FREQUENCY (CPS)         :
resonance : Q (0.0 - 1.0)           :
multimode : FILTER MODE (0.0 - 1.0) : LOW-NOTCH/BANDPASS-HIGH | 24DB - 6DB LOWPASS
bandpass  : 0 = FALSE, 1 = TRUE     : 0 = NOTCH, 1 = BANDPASS
fourpole  : 0 = FALSE, 1 = TRUE     : 0 = 12/DB MULTI-MODE, 1 = 24/DB LOWPASS

> g_01 =
>   let k = control KR
>       c1 = k "cutoff" 440.0
>       c2 = k "resonance" 0.0
>       c3 = k "multimode" 0.5
>       c4 = k "bandpass" 0.0
>       c5 = k "fourpole" 0.0
>   in rObxdFilter (pinkNoise 'α' AR * 0.5) c1 c2 c3 c4 c5

    > import Sound.OSC {- hosc -}
    > withSC3 (sendMessage (n_set1 (-1) "cutoff" 880.0))
    > withSC3 (sendMessage (n_set1 (-1) "resonance" 0.95))
    > withSC3 (sendMessage (n_set1 (-1) "multimode" 0.75))
    > withSC3 (sendMessage (n_set1 (-1) "bandpass" 1.0))
    > withSC3 (sendMessage (n_set1 (-1) "fourpole" 1.0))

> g_02 =
>   let cutoff = mouseX KR 110.0 (110.0 * 16) Exponential 0.2
>   in rObxdFilter (pinkNoise 'α' AR * 0.5) cutoff 0.0 0.0 0.0 0.0

> g_03 =
>   let cutoff = mouseX KR 110.0 (110.0 * 16) Exponential 0.2
>       resonance = mouseY KR 0.0 1.10 Linear 0.2
>   in rObxdFilter (pinkNoise 'α' AR * 0.5) cutoff resonance 0.5 0.0 0.0

multimode selects the filter mode, the range is (0,1), there are four modes.

> g_04 =
>   let cutoff = mouseX KR 110.0 (110.0 * 16) Exponential 0.2
>       multimode = mouseY KR 0.0 1.0 Linear 0.2
>       fourpole = 1.0
>   in rObxdFilter (pinkNoise 'α' AR * 0.5) cutoff 0.0 multimode 0.0 fourpole
