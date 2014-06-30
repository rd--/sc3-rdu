// A trace that traverses a diamond in equal time increments.
s.sendMsg("/b_alloc", 0, 20);
s.sendMsg("/b_setn", 0, 0, 20,
            0, -1, 1/4, 0,
            1/4, 0, 1/2, 0,
            1/2, 1, 1/4, 0,
            3/4, 0, 0, 0,
            1, -1, 1/4, 0);

// The X element of the trace is (-1 0 1 0 -1).
{var x = RTraceRd.kr(0, 4, LFSaw.kr(1, 0, 1/2, 1/2), 1)
;Out.ar(0,Pan2.ar(SinOsc.ar(440, 0, 0.5), x, 0.1))}.play

// The Y element is (1/4 1/2 1/4 0 1/4).
{var x = RTraceRd.kr(0, 4, LFSaw.kr(1, 0, 1/2, 1/2), 1)
;var y = RTraceRd.kr(0, 4, LFSaw.kr(1, 0, 1/2, 1/2), 2)
;Out.ar(0,Pan2.ar(SinOsc.ar(440, 0, 0.1), x, y))}.play

// Altering the time points...
s.sendMsg("/b_setn",
    0, 0, 20, 0, -1, 1/4, 0,
    1/8, 0, 1/2, 0,
    1/4, 1, 1/4, 0,
    1/2, 0, 0,  0,
    1, -1, 1/4, 0);

//Variant constructors with named accessor.
{var x = RTraceRdX.kr(0, 4, LFSaw.kr(1, 0, 1/2, 1/2))
;var y = RTraceRdY.kr(0, 4, LFSaw.kr(1, 0, 1/2, 1/2))
;Out.ar(0,Pan2.ar(SinOsc.ar(440, 0, 0.1), x, y))}.play

// Cleanup
s.sendMsg( "/b_free", 0)
