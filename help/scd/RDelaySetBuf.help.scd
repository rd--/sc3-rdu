// RDelaySetBuf - three one second delays
{var b = LocalBuf.new(numFrames: 5 * 48000, numChannels: 1).clear
;var i = SinOsc.ar(freq: MouseX.kr(minval: 110, maxval: 660, warp: 0, lag: 0.1), phase: 0, mul: MouseY.kr(minval: 0, maxval: 0.4, warp: 0, lag: 0.2))
;var d = RDelaySetBuf.ar(bufnum: b, in: i, spec: [1,1,1/5,2,1/2,1/10,3,1/3,1/15])
;[i,d]}
