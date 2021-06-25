// RDelaySet - three one second delays
{var s = SinOsc.ar(freq: MouseX.kr(minval: 110, maxval: 660, warp: 0, lag: 0.1), phase: 0, mul: MouseY.kr(minval: 0, maxval: 0.6, warp: 0, lag: 0.2))
;var d = RDelaySet.ar(in: s, spec: [1,1,1/5,2,1/2,1/10,3,1/3,1/15])
;[s,d]}

// RDelaySet - a lot of random delays
{var s = SinOsc.ar(freq: MouseX.kr(minval: 110, maxval: 660, warp: 0, lag: 0.1), phase: 0, mul: MouseY.kr(minval: 0, maxval: 0.4, warp: 0, lag: 0.2))
;var n = 10
;var a = [Array.fill(n,{5.0.rand})
         ,Array.fill(n,{(1/5) + (4/5).rand})
         ,Array.fill(n,{(1/40) + (1/40).rand})]
;[s,RDelaySet.ar(in: s, spec: a.flop.flatten)]}

// RDelaySet - delay memory is allocated with rtalloc, adjust to observe allocation failure
{var d = 10
;var s = SinOsc.ar(freq: MouseX.kr(minval: 110, maxval: 660, warp: 0, lag: 0.1), phase: 0, mul: MouseY.kr(minval: 0, maxval: 0.6, warp: 0, lag: 0.2))
;[s,RDelaySet.ar(in: s, spec: [d,1,1/5])] * 0.1}
