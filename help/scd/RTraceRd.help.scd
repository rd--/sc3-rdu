// RTraceRd - diamond trace, equal time increments, X element is (-1 0 1 0 -1)
{var b = LocalBuf.newFrom([0,-1,1/4,0, 1/4,0,1/2,0, 1/2,1,1/4,0, 3/4,0,0,0, 1,-1,1/4,0])
;var x = kr(RTraceRd,b,4,kr(LFSaw,1,0,1/2,1/2),1)
;ar(Pan2,ar(SinOsc,440,0,0.5),x,0.1)}

// RTraceRd - diamond trace, equal time increments, X element is (1/4 1/2 1/4 0 1/4)
{var b = LocalBuf.newFrom([0,-1,1/4,0, 1/4,0,1/2,0, 1/2,1,1/4,0, 3/4,0,0,0, 1,-1,1/4,0])
;var x = kr(RTraceRd,b,4,kr(LFSaw,1,0,1/2,1/2),1)
;var y = kr(RTraceRd,b,4,kr(LFSaw,1,0,1/2,1/2),2)
;ar(Pan2,ar(SinOsc,440,0,0.1),x,y)}

// RTraceRd - different trace, variant constructors with named accessor
{var b = LocalBuf.newFrom([0,-1,1/4,0, 1/8,0,1/2,0, 1/4,1,1/4,0, 1/2,0,0,0, 1,-1,1/4,0])
;var x = kr(RTraceRdX,b,4,kr(LFSaw,1,0,1/2,1/2))
;var y = kr(RTraceRdY,b,4,kr(LFSaw,1,0,1/2,1/2))
;ar(Pan2,ar(SinOsc,440,0,0.1),x,y)}
