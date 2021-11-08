// RDelayMap - one second delay at quarter gain
{var b = LocalBuf.new(numFrames: 2 * 48000, numChannels: 1).clear
;var a = [-1,0,0,0.5,1,-1,0,1]
;var x = MouseX.kr(minval: 110, maxval: 440, warp: 0, lag: 0.1)
;var y = MouseY.kr(minval: 0.0, maxval: 0.2, warp: 0, lag: 0.1)
;var o = SinOsc.ar(freq: x, phase: 0) * y
;[RDelayMap.ar(bufnum: b, in: o, dynamic: 0, spec: a), o]}

// RDelayMap ; event control
{var voiceFunc =
 {arg e
 ;var b = LocalBuf.new(numFrames: 2 * 48000, numChannels: 1).clear
 ;var a = [-1,e.y,0,0.5,1.5,-1,0,1]
 ;var f = (e.x * 24 + 48).midicps
 ;var o = SinOsc.ar(freq: f, phase: 0) * e.z * Lag.kr(in: e.w, lagTime: 5)
 ;[RDelayMap.ar(bufnum: b, in: o, dynamic: 0, spec: a),o]}
;Mix.ar(Voicer.ar(numVoices: 16, voiceFunc: voiceFunc))}

//---- ui
REventUI.new(frameRate: 60, areaWidth: 230, areaHeight: 130, areaScaling: 2.5, gridFileName: nil).makeWindow;
