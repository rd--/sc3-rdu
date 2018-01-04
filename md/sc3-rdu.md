## DustR

Generates triggers where the inter-offset times are generated randomly
in the specified range (seconds) with linear distribution.

[[help.lhs](?t=sc3-rdu&e=help/lhs/dustR.help.lhs),
 [help.scd](?t=sc3-rdu&e=help/scd/DustR.help.scd),
 [help.scm](?t=sc3-rdu&e=help/scm/dust-r.help.scm)]

## PV_Split

Variant of `PV_Copy` that returns both signal paths.

`PV_Copy` graphs have two linear orderings that are not equivalent.

~~~~
... -> fft -> ... .-> pv_copy -> pv1 -> ifft -> ...
                  |
                  .-> pv2 -> ifft -> ...
~~~~

`PV_Split` graphs also have two _equivalent_ linear orderings.

~~~~
                              .-> pv1 -> ifft1 -> ...
... -> fft -> ... -> pv_split |
                              .-> pv2 -> ifft2 -> ...
~~~~

[[help.lhs](?t=sc3-rdu&e=help/lhs/pv_split.help.lhs)]

## *RandN

`ExpRandN`, `IRandN`, `LinRandN` and `RandN`.  Multiple channel
variants of the standard SC3 UGens.

[[expRandN.help.lhs](?t=sc3-rdu&e=help/lhs/expRandN.help.lhs),
 [randN.help.lhs](?t=sc3-rdu&e=help/lhs/randN.help.lhs)]

## RDelayMap

Network of delay line maps

Create a network of delay line maps.  A map is defined by a
quadruple: source location, destination location, operation and
gain.  The locations are specified in seconds, a negative location
specifies the 'input' location for sources and the 'output'
location for destinations.  The operation is specified as an
integer, zero is move, one is add, two is subtract, three is
multiply, four is divide.  The gain is linear.  This UGen is
useful for implementing nested filters, as described by William
Gardner in his MS thesis _The Virtual Acoustic Room_, MIT 1992.

[[help.lhs](?t=sc3-rdu&e=help/lhs/rDelayMap.help.lhs),
 [help.scd](?t=sc3-rdu&e=help/scd/RDelayMap.help.scd),
 [help.scm](?t=sc3-rdu&e=help/scm/r-delay-map.help.scm)]

## RDelaySet*

Set of delays, with buffer variant.

[[RDelaySet.help.lhs](?t=sc3-rdu&e=help/lhs/rDelaySet.help.lhs),
 [RDelaySet.help.scd](?t=sc3-rdu&e=help/scd/RDelaySet.help.scd),
 [RDelaySetB.help.lhs](?t=sc3-rdu&e=help/lhs/rDelaySetB.help.lhs),
 [RDelaySetB.help.scd](?t=sc3-rdu&e=help/scd/RDelaySetB.help.scd)]

## RDL

DSP dynamic library host for [hdf](?t=hdf) data-flow graphs.

[[help.lhs](?t=sc3-rdu&e=help/lhs/rdl.help.lhs)]

## RFreezer

Concurrent loops at a signal buffer

Create a set of concurrent loops at a signal buffer.  This is the
dynamic and gestural variant of RLoopSet.  It was written after
reading the manual for the GRM Tools 'Freeze' plugin.

[[help.lhs](?t=sc3-rdu&e=help/lhs/rFreezer.help.lhs),
 [help.scd](?t=sc3-rdu&e=help/scd/RFreezer.help.scd)]

## RLoopSet

Concurrent loops at a signal buffer

Create a set of concurrent loops at a signal buffer.  This is the
static and composed variant of RFreezer.  There are five global
inputs, the buffer and then: left, right, gain and increment.  The
first two are initialization rate, the second two control rate.
Each loop is defined by a quadruple: left, right, gain and
increment.  The left and right values are in the range [0,1) and
refer to the segment of the buffer established by the group left
and right values, which are in the range [0,1) in relation to the
signal buffer.

~~~~
Buffer Left                                  Buffer Right
|                                                       |
|      Group Left              Group Right              |
|      |                                 |              |
|------|----|-----------------------|----|--------------|
            |                       |
            Loop Left      Loop Right
~~~~

[[help.scd](?t=sc3-rdu&e=help/scd/RLoopSet.help.scd)]

## RPlayTrace

Play a buffer that is arranged as a trace.  A trace is a sequence of
tuples (T,X,Y,Z).

[[help.lhs](?t=sc3-rdu&e=help/lhs/rPlayTrace.help.lhs)]

## RPVDecayTbl

A `PV` unit generator that tracks the rise of magnitudes immediately,
but decays them according to a set of multipliers given in a table.
At each frame each partial decays by the amount indicated in the table,
if the decaying value is below the input value it is reset.

[[help.lhs](?t=sc3-rdu&e=help/lhs/rpvDecayTbl.help.lhs)]

## RShufflerB

A signal shuffler

[[help.lhs](?t=sc3-rdu&e=help/lhs/rShufflerB.help.lhs),
 [help.scd](?t=sc3-rdu&e=help/scd/RShufflerB.help.scd)]

## RShufflerL

Linear signal shuffler.

[[help.lhs](?t=sc3-rdu&e=help/lhs/rShufflerL.help.lhs),
 [help.scd](?t=sc3-rdu&e=help/scd/RShufflerL.help.scd)]

## RTraceRd

Read a buffer that is arranged as a trace.  A trace is a sequence of
tuples (T,X,Y,Z).

[[help.lhs](?t=sc3-rdu&e=help/lhs/rTraceRd.help.lhs),
 [help.scd](?t=sc3-rdu&e=help/scd/RTraceRd.help.scd)]

## TScramble

Scramble inputs on trigger.

[[help.lhs](?t=sc3-rdu&e=help/lhs/tScramble.help.lhs)]
