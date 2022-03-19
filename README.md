sc3-rdu
-------

[supercollider3](http://audiosynth.com/) unit generators

- Bezier - Bézier curve oscillator
- DX7 - Raph Levien and Pascal Gauthier DX7 emulation
- DustRange - Dust variant with inter-offset times generated randomly within range
- ExpRandN - n-channel variant of ExpRand
- Freezer - variant of GRM Freeze processor
- IRandN - n-channel variant of IRand
- LinRandN - n-channel variant of LinRand
- ObxdFilter - Filatov Vadim filter from Obxd
- PV_Split - copy PV buffer, graph coherent variant of PV_Copy
- RDL - load DSP code from dynamic library
- RDelayMap - ?
- RDelaySet - ?
- RDelaySetB - ?
- RDX7Env - ?
- RLoopSet - ?
- RPVDecayTbl - ?
- RPlayTrace - ?
- RShufflerL - ?
- RTraceRd - ?
- RandN - n-channel variant of Rand
- SvfBp - band-pass state variable filter
- SvfHp - high-pass state variable filter
- SvfLp - low-pass state variable filter
- ShufflerB - variant of GRM Shuffling processor
- TRandN - n-channel variant of TRand
- TLinRandN - n-channel variant of TLinRand
- TScramble - signal router, scramble mapping on trigger

Pseudo unit generators:

- ADSR - Attack-decay-sustain-release envelope (Env, EnvGen)
- ASR - Attack-sustain-release envelope (Env, EnvGen)
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

© [rohan drape](http://rohandrape.net/), 1998-2022, [gpl](http://gnu.org/copyleft/)
