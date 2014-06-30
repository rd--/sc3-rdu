// a = noise, b = impulses
{var a = DustR.ar(0.0001,0.001) * 0.1
;var b = DustR.ar(0,2)
;Out.ar(0,[a,b])}.play;
