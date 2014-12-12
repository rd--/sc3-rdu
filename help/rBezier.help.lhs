> import Sound.SC3

rBezier :: Rate -> UGen -> UGen -> UGen -> UGen

> let rBezier rate freq phase param = mkUGen Nothing [AR] (Left rate) "RBezier" [freq,phase] (Just param) 1 (Special 0) NoId

> audition (out 0 (sinOsc AR 440 0 * 0.25))

> let x = mouseX KR 40 4000 Exponential 0.2
> let g = rBezier AR x 0 (mce [0,0,0.2,-1.3,0.3,-1.3,0.5,0,0.7,1.3,0.8,1.3,1,0]) * 0.1

> let x = mouseX KR 40 4000 Exponential 0.2
> let y = mouseY KR 0.1 0.2 Linear 0.2
> let g = rBezier AR x 0 (mce [0,0,y,-1.3,0.3,-1.3,0.5,0,0.7,1.3,0.8,1.3,1,0]) * 0.1

> import Sound.SC3.Plot

> plot_ugen1 0.1 g

> audition (out 0 g)
