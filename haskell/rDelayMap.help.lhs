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

Allocate buffer, required for all examples below.

> withSC3 (\fd -> do reset fd
>                    send fd (b_alloc 0 88200 1)
>                    wait fd "/done")

Zero buffer (transitioning between examples may require the buffer to
be cleared)

> withSC3 (\fd -> do reset fd
>                    send fd (b_zero 0)
>                    wait fd "/done")

Simple delay (static)

> let rDelayMap b i d s = mkFilterMCE "RDelayMap" [b,i,d] s 1 0
>     a = MCE [-1, 0, 0, 0.5, 1, -1, 0, 1.0]
>     x = mouseX KR 110 440 Linear 0.1
>     y = mouseY KR 0.0 0.2 Linear 0.1
>     s = sinOsc AR x 0 * y
> audition (MCE [rDelayMap 0 s 0 a, s])

Simple feedback circuit (static)

> let rDelayMap b i d s = mkFilterMCE "RDelayMap" [b,i,d] s 1 0
> n <- whiteNoise AR
> let s = decay (impulse AR (5/4) 0) 0.1 * n * 0.2
>     a = MCE [-1, 0, 0, 1, 1/9, 0, 1, 8/9, 1, -1, 0, 1]
> audition (rDelayMap 0 s 0 a)

Simple feedback circuit (dynamic)

> let rDelayMap b i d s = mkFilterMCE "RDelayMap" [b,i,d] s 1 0
> n <- whiteNoise AR
> let s = decay (impulse AR (MCE [1/3, 5/4]) 0) 0.1 * n * 0.2
>     x = mouseX KR 0.05 1.05 Linear 0.1
>     y = mouseY KR 0.05 0.95 Linear 0.1
>     a = MCE [-1, 0, 0, 1, y, 0, 1, x, 1, -1, 0, 1]
> audition (rDelayMap 0 s 1 a)
