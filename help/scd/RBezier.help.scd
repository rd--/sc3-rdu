// RBezier - reference sine tone
{SinOsc.ar(440,0) * 0.1}

// RBezier - bezier approximation of sin function
{RBezier.ar(440,0,[0,0,0.2,-1.3,0.3,-1.3,0.5,0,0.7,1.3,0.8,1.3,1,0]) * 0.1}

// RBezier - mouse control of frequency
{var x = MouseX.kr(40,4000,'exponential',0.2)
;RBezier.ar(x,0,[0,0,0.2,-1.3,0.3,-1.3,0.5,0,0.7,1.3,0.8,1.3,1,0]) * 0.1}

// RBezier - mouse control of frequency & one control point
{var x = MouseX.kr(40,4000,'exponential',0.2)
;var y = MouseY.kr(0.1,0.2,'linear',0.2)
;RBezier.ar(x,0,[0,0,y,-1.3,0.3,-1.3,0.5,0,0.7,1.3,0.8,1.3,1,0]) * 0.1}

// RBezier - dynamic shifting of control points, as oscillator
{var w = {arg l, r; LFDNoise3.ar(2).range(l,r)}
;Mix.fill(4,
 {var p = [0,0,w.(0.05,0.25),-1.3,w.(0.25,0.45),-1.3,0.5,0,w.(0.55,0.75),1.3,w.(0.75,0.95),1.3,1,0]
 ;var o = RBezier.ar(w.(200,205),0,p)
 ;Pan2.ar(o,IRand(-1,1),0.1)})}
