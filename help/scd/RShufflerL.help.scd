// RShufflerL - unary node
{var o = ar(SinOsc,[440,441],0) * 0.2
;var x = kr(MouseX,0.0001,0.2)
;var y = kr(MouseY,0.001,0.2,\exponential)
;ar(RShufflerL,o,x,y)}

// RShufflerL - parallel node banks
{var n = 6
;var o = ar(SinOsc,[440,441],0) * 0.2
;var x = kr(MouseX,0.0001,0.02)
;var y = kr(MouseY,0.001,0.25,1)
;var f = x * fill(Array,n,{rand(4.0)})
;var d = y * fill(Array,n,{rand(4.0)})
;ar(Splay,ar(RShufflerL,o,f,d))}
