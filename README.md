sc3-rdu
-------

[supercollider3](http://audiosynth.com/) unit generators

- Bezier - Bézier curve oscillator
- BufMemCpy - ?
- DustRange - Dust variant with inter-offset times generated randomly within range
- DX7 - Raph Levien and Pascal Gauthier DX7 emulation
- ExpRandN - n-channel variant of ExpRand
- Freezer - variant of GRM Freeze processor
- IRandN - n-channel variant of IRand
- LinRandN - n-channel variant of LinRand
- MVerb - Dattorro’s figure-of-eight reverb structure by Martin Eastwood
- ObxdFilter - Filatov Vadim filter from Obxd
- PinkingFilterPk3 - Paul Kellet's refined method
- PV\_Split - copy PV buffer, graph coherent variant of PV_Copy
- RandN - n-channel variant of Rand
- RDL - load DSP code from dynamic library
- RDelaySet - ?
- RDelaySetB - ?
- RDelayMap - ?
- RDX7Env - ?
- RLagC - ?
- RLoopSet - ?
- RPVDecayTbl - ?
- RShufflerL - ?
- RTracePlay - ?
- RTraceRd - ?
- SamplerIndex - ?
- ShufflerB - variant of GRM Shuffling processor
- SvfBp - band-pass state variable filter
- SvfHp - high-pass state variable filter
- SvfLp - low-pass state variable filter
- TExpRandN - n-channel variant of TExpRand
- TLinRandN - n-channel variant of TLinRand
- TRandN - n-channel variant of TRand
- TScramble - signal router, scramble mapping on trigger
- TSort - signal router, sort mapping on trigger

Pseudo unit generators:

- Adsr - Attack-decay-sustain-release envelope (Env, EnvGen)
- Asr - Attack-sustain-release envelope (Env, EnvGen)
- Cc - Continous controller input (In)
- Cutoff - Sustain time and release time envelope (Env, EnvGen)
- LinSeg - Line segment envelope (Env, EnvGen)
- REvent - ?
- RingzBank - Bank of Ringz filters (Klank, Ref)
- Select2 - Predicate to select one of two signals (*, -, +)
- SinOscBank - Bank of FSinOsc oscillators (Klang, Ref)
- Sw - Switch controller input (In)
- TLine - Line envelope (Env, EnvGen)
- TLineTo - Line envelope (TLine, TDelay, Latch)
- TXLine - Line envelope (Env, EnvGen)
- TXLineTo - Line envelope (TXLine, TDelay, Latch)
- Tr - Timed trigger (Trig, SampleDur, ControlDur)
- Tr1 - Timed trigger (Trig1, SampleDur, ControlDur)

requires: [r-common](?t=r-common)

debian: supercollider-dev

tested-with:

- [gcc](http://gcc.gnu.org/) 11.2.0
- [clang](https://clang.llvm.org/) 13.0.1

references:

- msfa: <https://github.com/google/music-synthesizer-for-android>
- dexed: <https://github.com/asb2m10/dexed>
- mverb: <https://github.com/martineastwood/mverb>

© [rohan drape](http://rohandrape.net/), 1998-2022, [gpl](http://gnu.org/copyleft/)
