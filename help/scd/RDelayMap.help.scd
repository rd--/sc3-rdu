// RDelayMap - one second delay at quarter gain
{var b = LocalBuf(2 * 48000,1).clear
;var a = [-1,0,0,0.5,1,-1,0,1]
;var x = kr(MouseX,110,440,0,0.1)
;var y = kr(MouseY,0.0,0.2,0,0.1)
;var o = ar(SinOsc,x,0) * y
;[ar(RDelayMap,b,o,0,a),o]}
