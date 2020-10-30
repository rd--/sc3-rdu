// RDelaySetB - three one second delays
{var b = LocalBuf(5 * 48000,1).clear
;var i = ar(SinOsc,kr(MouseX,110,660,0,0.1),0,kr(MouseY,0,0.4))
;var d = ar(RDelaySetB,b,i,[1,1,1/5,2,1/2,1/10,3,1/3,1/15])
;[i,d]}
