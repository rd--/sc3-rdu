> import Sound.SC3 {- hsc3 -}
> import Sound.SC3.UGen.Bindings.DB.RDU {- sc3-rdu -}

    Sound.SC3.UGen.DB.Record.u_summary Sound.SC3.UGen.External.RDU.tScramble_dsc

two channel sin tones, channels scramble on impulse, scramble may be identity

> g_01 =
>     let tr = impulse KR 1 0
>     in sinOsc AR (tScramble 'α' tr (mce2 440 880)) 0 * 0.1

c-major octave 4 sin tones across stereo field, scrambles on impulse

> g_02 =
>     let tr = impulse KR 1 0
>         f = tScramble 'α' tr (mce (map midiCPS [60,62,64,65,67,69,71]))
>     in splay (sinOsc AR f 0 * 0.1) 1 1 0 True
