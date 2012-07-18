/*
RDelayMap buffer in dynamic spec

Create a network of delay line maps.  A map is defined by a
quadruple: source location, destination location, operation and
gain.  The locations are specified in seconds, a negative location
specifies the 'input' location for sources and the 'output'
location for destinations.  The operation is specified as an
integer, zero is move, one is add, two is subtract, three is
multiply, four is divide.  The gain is linear.  This UGen is
useful for implementing nested filters, as described by William
Gardner in his MS thesis 'The Virtual Acoustic Room', MIT 1992.
*/

// Allocate buffer, required for all examples below.
s.sendMsg("/b_alloc", 0, 2 * 44100, 1);

// Zero buffer (transitioning between examples may require the buffer
// to be cleared)
s.sendMsg("/b_zero",0);

// Trivial one second delay at quarter gain.
{var a = [-1, 0, 0, 0.5, 1, -1, 0, 1]
;var x = MouseX.kr(110, 440, 0, 0.1)
;var y = MouseY.kr(0.0, 0.2, 0, 0.1)
;var o = SinOsc.ar(x, 0) * y
;[RDelayMap.ar(0,o,0,a), o]}.play


