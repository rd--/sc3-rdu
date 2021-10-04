sc3-rdu
-------

[supercollider3](http://audiosynth.com/) unit generators

- DustR:
  .help.{[hs](?t=hsc3&e=Help/UGen/dustR.help.hs)
         [scd](?t=sc3-rdu&e=help/scd/DustR.help.scd)
         [scm](?t=rsc3&e=help/ugen/dust-r.help.scm)}
  .[cpp](?t=sc3-rdu&e=cpp/DustR.cpp)
- PV_Split:
  .help.{[lhs](?t=sc3-rdu&e=help/lhs/pv_split.help.lhs)}
  .[cpp](?t=sc3-rdu&e=cpp/PV_Split.cpp)
- {Exp,I,Lin,T}RandN
  - ExpRandN:
    .help.{[hs](?t=hsc3&e=Help/UGen/expRandN.help.hs)}
  - RandN:
    .help.{[hs](?t=hsc3&e=Help/UGen/randN.help.hs)}
  - .[cpp](?t=sc3-rdu&e=cpp/RandN.cpp)
- RDelayMap:
  .help.{[hs](?t=hsc3&e=Help/UGen/rDelayMap.help.hs)
        [scd](?t=sc3-rdu&e=help/scd/RDelayMap.help.scd)
        [scm](?t=rsc3&e=help/ugen/r-delay-map.help.scm)}
  .[cpp](?t=sc3-rdu&e=cpp/RDelayMap.cpp)
- RDelaySet:
  .help.{[hs](?t=hsc3&e=Help/UGen/rDelaySet.help.hs)
         [scd](?t=sc3-rdu&e=help/scd/RDelaySet.help.scd)}
  .[cpp](?t=sc3-rdu&e=cpp/RDelaySet.cpp)
- RDelaySetB
  .help.{[hs](?t=hsc3&e=Help/UGen/rDelaySetB.help.hs)
         [scd](?t=sc3-rdu&e=help/scd/RDelaySetB.help.scd)}
  .[cpp](?t=sc3-rdu&e=cpp/RDelaySetB.cpp)
- RDL:
  .help.{[hs](?t=hsc3&e=Help/UGen/rdl.help.hs)}
  .[cpp](?t=sc3-rdu&e=cpp/RDL.cpp)
- RDX7:
  .help.{[hs](?t=hsc3&e=Help/UGen/rdx7.help.hs)
        [scd](?t=sc3-rdu&e=help/scd/RDX7.help.scd)}
  .[cpp](?t=sc3-rdu&e=cpp/RDX7.cpp)
  .[patch](sw/sc3-rdu/ext/patch/)
  [mk](sw/sc3-rdu/cpp/dx7/Makefile)
  (Raph Levien, Pascal Gauthier)
- REvent:
  .help.[scd](?t=sc3-rdu&e=help/scd/REvent.help.scd)
  .[sc](?t=sc3-rdu&e=sc/revent.sc)
- RFreezer:
  .help.{[hs](?t=hsc3&e=Help/UGen/rFreezer.help.hs)
        [scd](?t=sc3-rdu&e=help/scd/RFreezer.help.scd)}
  .[cpp](?t=sc3-rdu&e=cpp/RFreezer.cpp)
- RLoopSet:
  .help.{[hs](?t=hsc3&e=Help/UGen/rLoopSet.help.hs)
        [scd](?t=sc3-rdu&e=help/scd/RLoopSet.help.scd)}
  .[cpp](?t=sc3-rdu&e=cpp/RLoopSet.cpp)
- RObxdFilter:
  .help.{[hs](?t=hsc3&e=Help/UGen/rObxdFilter.help.hs)}
  .[cpp](?t=sc3-rdu&e=cpp/RObxdFilter.cpp)
  (Filatov Vadim)
- RTrace*:
  - RPlayTrace:
    .help.{[hs](?t=hsc3&e=Help/UGen/rPlayTrace.help.hs)}
  - RTraceRd:
    .help.{[hs](?t=hsc3&e=Help/UGen/rTraceRd.help.hs)
          [scd](?t=sc3-rdu&e=help/scd/RTraceRd.help.scd)}
  - .[cpp](?t=sc3-rdu&e=cpp/RTrace.cpp)
- RPVDecayTbl:
  .help.{[hs](?t=hsc3&e=Help/UGen/rpvDecayTbl.help.hs)}
  .[cpp](?t=sc3-rdu&e=cpp/RPVDecay.cpp)
- RShufflerB:
  .help.{[hs](?t=hsc3&e=Help/UGen/rShufflerB.help.hs)
         [scd](?t=sc3-rdu&e=help/scd/RShufflerB.help.scd)}
  .[cpp](?t=sc3-rdu&e=cpp/RShufflerB.cpp)
- RShufflerL:
  .help.{[hs](?t=hsc3&e=Help/UGen/rShufflerL.help.hs)
         [scd](?t=sc3-rdu&e=help/scd/RShufflerL.help.scd)}
  .[cpp](?t=sc3-rdu&e=cpp/RShufflerL.cpp)
- TScramble:
  .help.{[hs](?t=hsc3&e=Help/UGen/tScramble.help.hs)}
  .[cpp](?t=sc3-rdu&e=cpp/TScramble.cpp)

requires: [c-commonr](?t=c-commonr)

debian: supercollider-dev

tested-with:

- [gcc](http://gcc.gnu.org/) 10.2.1
- [clang](https://clang.llvm.org/) 11.0.1

© [rohan drape](http://rohandrape.net/), 1998-2021, [gpl](http://gnu.org/copyleft/)