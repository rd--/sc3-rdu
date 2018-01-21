// Allocate buffer
s.sendMsg("/b_alloc", 0, 5 * 44100, 1);

// Three one second delays...
{var i = SinOsc.ar(MouseX.kr(110, 660, 0, 0.1), 0, MouseY.kr(0, 0.4))
;var d = RDelaySetB.ar(0, i, [1, 1, 1/5, 2, 1/2, 1/10, 3, 1/3, 1/15])
;Out.ar(0,[i, d])}.play

// Cleanup
s.sendMsg("/b_free", 0);