// allocate buffer
sendMsg(s,"/b_alloc",0,2 * 44100,1);

// zero buffer (transitioning between examples may require the buffer to be cleared)
sendMsg(s,"/b_zero",0);

// one second delay at quarter gain.
{var a = [-1,0,0,0.5,1,-1,0,1]
;var x = kr(MouseX,110,440,0,0.1)
;var y = kr(MouseY,0.0,0.2,0,0.1)
;var o = ar(SinOsc,x,0) * y
;ar(Out,0,[ar(RDelayMap,0,o,0,a),o])}.play
