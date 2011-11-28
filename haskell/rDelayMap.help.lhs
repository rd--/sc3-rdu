rDelayMap bufnum input dynamic mapArray

Create a network of delay line maps.  A map is defined by a quadruple:
source location, destination location, operation and gain.  The
locations are specified in seconds, a negative location specifies the
'input' location for sources and the 'output' location for
destinations.  The operation is specified as an integer, zero is move,
one is add, two is subtract, three is multiply, four is divide.  The
gain is linear.

This UGen may be useful for implementing nested filters, as described
by William Gardner in his MS thesis 'The Virtual Acoustic Room', MIT
1992.

bufnum   - single channel buffer
input    - input signal
dynamic  - when > 0 the mapArray is k-rate, else i-rate
mapArray - set of quadruples

> import Sound.SC3.ID

Allocate buffer, required for all examples below.
> withSC3 (\fd -> async fd (b_alloc 0 88200 1))

Zero buffer (transitioning between examples may require the buffer to
be cleared)
> withSC3 (\fd -> async fd (b_zero 0))

Define UGen
> let rDelayMap b i d s = mkFilterMCE "RDelayMap" [b,i,d] s 1

Simple delay (static)
> let {a = mce [-1,0,0,0.5,1,-1,0,1.0]
>     ;x = mouseX' KR 110 440 Linear 0.1
>     ;y = mouseY' KR 0.0 0.2 Linear 0.1
>     ;o = sinOsc AR x 0 * y }
> in audition (out 0 (mce [rDelayMap 0 o 0 a,o]))

Simple feedback circuit (static)
> let {n = whiteNoise 'α' AR
>     ;s = decay (impulse AR (5/4) 0) 0.1 * n * 0.2
>     ;a = mce [-1,0,0,1,1/9,0,1,8/9,1,-1,0,1]}
> in audition (out 0 (rDelayMap 0 s 0 a))

Simple feedback circuit (dynamic)
> let {n = whiteNoise 'α' AR
>     ;s = decay (impulse AR (mce [1/3,5/4]) 0) 0.1 * n * 0.2
>     ;x = mouseX' KR 0.05 1.05 Linear 0.1
>     ;y = mouseY' KR 0.05 0.95 Linear 0.1
>     ;a = mce [-1,0,0,1,y,0,1,x,1,-1,0,1]}
> in audition (out 0 (rDelayMap 0 s 1 a))
