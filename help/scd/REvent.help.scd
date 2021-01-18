// blip ; event control
{var f = {arg e; Pan2.ar(Blip.ar(e.p.midicps,e.y * 10 + 1),e.o * 2 - 1,e.g * e.z)}
;Mix.ar(REventVoicer.new(16,f)) * NamedControl.kr("gain",0.5)}

// membraneCircle ; event control
{var f =
 {arg e
 ;var loss = LinExp.kr(e.y,0,1,0.99999,0.99950)
 ;var wobble = SinOsc.kr(2,0)
 ;var tension = LinExp.kr(e.x,0,1,0.01,0.1) + (wobble * 0.0001)
 ;var env = EnvGen.kr(Env.perc(0.0001,1 - e.z),e.g,e.z + (e.y / 4),0,0.1,0)
 ;Pan2.ar(MembraneCircle.ar(PinkNoise.ar * env,tension,loss),e.o * 2 - 1,1)}
;Mix.ar(REventVoicer(6,f)) * NamedControl.kr("gain",1)}

// pluck ; event control
{var f =
 {arg e
 ;var n = WhiteNoise.ar * e.z
 ;var dl_max = 1 / 220
 ;var dl = dl_max * (1 - e.x * 0.9)
 ;Pan2.ar(Pluck.ar(n,e.g,dl_max,dl,10,e.y / 3),e.o * 2 - 1,1)}
;Mix.ar(REventVoicer.new(16,f)) * NamedControl.kr("gain",2)}

// resonz ; pinkNoise ; event control
{var f = {arg e; Pan2.ar(Resonz.ar(PinkNoise.ar,e.p.midicps,e.y * 0.25) * 24,e.o * 2 - 1,e.z * e.g)}
;Mix.ar(REventVoicer.new(16,f)) * NamedControl.kr("gain",1)}
