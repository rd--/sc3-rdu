## DustR

Generates triggers where the inter-offset times are generated randomly
in the specified range (seconds) with linear distribution.

## ExpRandN, IRandN, LinRandN, RandN

Multiple channel variants of the standard SC3 UGens.

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
Gardner in his MS thesis 'The Virtual Acoustic Room', MIT 1992.

## RDelaySetB

Buffer variant of RDelaySet

## RDelaySet

Set of delays

## RFreezer

Concurrent loops at a signal buffer

Create a set of concurrent loops at a signal buffer.  This is the
dynamic and gestural variant of RLoopSet.  It wass written after
reading the manual for the GRM Tools 'Freeze' plugin.

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

## RShufflerB

A signal shuffler

## RShufflerL

Linear Shuffler

## RTraceRd

Read a buffer that is arranged as a trace.  A trace is a sequence of
tuples (T,X,Y,Z).
