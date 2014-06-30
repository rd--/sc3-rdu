// Allocate buffer
s.sendMsg("/b_alloc", 0, 2 * 44100, 1);

// Zero buffer (transitioning between examples may require the buffer to be cleared)
s.sendMsg("/b_zero",0);

// One second delay at quarter gain.
{var a = [-1, 0, 0, 0.5, 1, -1, 0, 1]
;var x = MouseX.kr(110, 440, 0, 0.1)
;var y = MouseY.kr(0.0, 0.2, 0, 0.1)
;var o = SinOsc.ar(x, 0) * y
;Out.ar(0,[RDelayMap.ar(0,o,0,a), o])}.play
