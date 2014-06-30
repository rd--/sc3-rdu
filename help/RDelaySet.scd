// Three one second delays...
{var s = SinOsc.ar(MouseX.kr(110,660,0,0.1),0,MouseY.kr(0,0.6))
;var d = RDelaySet.ar(s,[1, 1, 1/5, 2, 1/2, 1/10, 3, 1/3, 1/15])
;Out.ar(0,[s, d])}.play

// A lot of random delays...
{var s = SinOsc.ar(MouseX.kr(110,660,0,0.1),0,MouseY.kr(0,0.4))
;var n = 10
;var a = [Array.fill(n,{5.0.rand})
         ,Array.fill(n,{(1/5)+(4/5).rand})
         ,Array.fill(n,{(1/40)+(1/40).rand})].postln
;Out.ar(0,[s, RDelaySet.ar(s,a.flop.flatten)])}.play

// The delay memory is allocated with RTAlloc.
// Adjust d to observe allocation failure.
{var d = 30
;s = SinOsc.ar(MouseX.kr(110,660,0,0.1),0,MouseY.kr(0,0.6))
;Out.ar(0,[s,RDelaySet.ar(s,[d,1,1/5])])}.play
