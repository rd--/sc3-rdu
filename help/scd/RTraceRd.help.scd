// a trace that traverses a diamond in equal time increments.
sendMsg(s,"/b_alloc",0,20);
sendMsg(s,"/b_setn",0,0,20, 0,-1,1/4,0, 1/4,0,1/2,0, 1/2,1,1/4,0, 3/4,0,0,0, 1,-1,1/4,0);

// the X element of the trace is (-1 0 1 0 -1).
{var x = kr(RTraceRd,0,4,kr(LFSaw,1,0,1/2,1/2),1)
;ar(Out,0,ar(Pan2,ar(SinOsc,440,0,0.5),x,0.1))}.play

// the Y element is (1/4 1/2 1/4 0 1/4).
{var x = kr(RTraceRd,0,4,kr(LFSaw,1,0,1/2,1/2),1)
;var y = kr(RTraceRd,0,4,kr(LFSaw,1,0,1/2,1/2),2)
;ar(Out,0,ar(Pan2,ar(SinOsc,440,0,0.1),x,y))}.play

// Altering the time points...
sendMsg(s,"/b_setn", 0,0,20, 0,-1,1/4,0, 1/8,0,1/2,0, 1/4,1,1/4,0, 1/2,0,0,0, 1,-1,1/4,0);

// variant constructors with named accessor
{var x = kr(RTraceRdX,0,4,kr(LFSaw,1,0,1/2,1/2))
;var y = kr(RTraceRdY,0,4,kr(LFSaw,1,0,1/2,1/2))
;ar(Out,0,ar(Pan2,ar(SinOsc,440,0,0.1),x,y))}.play

// cleanup
sendMsg(s,"/b_free",0)
