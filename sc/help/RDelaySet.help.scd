/* RDelaySet in spec */

// Three one second delays...
{var s = SinOsc.ar(MouseX.kr(110,660,0,0.1),0,MouseY.kr(0,0.6))
;[s, RDelaySet.ar(s,[1, 1, 1/5, 2, 1/2, 1/10, 3, 1/3, 1/15])]}.play

// A lot of random delays...
{var s = SinOsc.ar(MouseX.kr(110,660,0,0.1),0,MouseY.kr(0,0.4))
;var n = 10
;var a = [Array.fill(n,{5.0.rand})
         ,Array.fill(n,{(1/5)+(4/5).rand})
         ,Array.fill(n,{(1/40)+(1/40).rand})].postln
;[s, RDelaySet.ar(s,a.flop.flatten)]}.play

// A delay that will not get the memory it requests with the default
// allocation.  The failure is not caught and the UGen causes
// problems...
{RDelaySet.ar(In.ar(2,2),[20,1,1/5])}.play
