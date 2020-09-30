// a = noise, b = impulses
{var a = ar(DustR,0.0001,0.001) * 0.1
;var b = ar(DustR,0.1,0.1) * 0.5
;ar(Out,0,[a,b])}.play
