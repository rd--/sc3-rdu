// allocate buffer
sendMsg(s,"/b_alloc",0,5 * sampleRate(s),1);

// three one second delays...
{var i = ar(SinOsc,kr(MouseX,110,660,0,0.1),0,kr(MouseY,0,0.4))
;var d = ar(RDelaySetB,0,i,[1,1,1/5,2,1/2,1/10,3,1/3,1/15])
;ar(Out,0,[i,d])}.play

// cleanup
sendMsg(s,"/b_free",0);
