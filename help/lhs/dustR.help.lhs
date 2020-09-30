    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.dustR_dsc

Generates triggers where the inter-offset times are generated randomly
in the specified range (seconds) with linear distribution.

> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

audio rate impulse train of varying amplitude (min = max)

> g_01 = mce2 (dustR 'α' AR 0.1 0.1 * 0.1) (impulse AR 10 0 * 0.1)

mean iot=0.0005 at dustR is equivalent to density=2000 at dust, dustR spacing is more uniform

> g_02 = mce2 (dustR 'β' AR 0.0001 0.001 * 0.1) (dust 'γ' AR 2000 * 0.05)

Drawings:

    import Sound.SC3.Plot {- hsc3-plot -}
    plot_ugen_nrt (48000,64) 1.0 (dustR 'δ' AR 0.1 0.1)
    plot_ugen_nrt (48000,64) 1.0 (dustR 'ε' AR 0.1 0.1 + impulse AR 10 0 * 0.5)
    plot_ugen_nrt (48000,64) 0.1 (dustR 'ζ' AR 0.0001 0.001)
    plot_ugen_nrt (48000,64) 0.1 (dust 'ζ' AR 2000)
