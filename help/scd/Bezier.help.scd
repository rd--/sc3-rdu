// Bezier ; reference sine tone
SinOsc.ar(freq: 440, phase: 0) * 0.1

// Bezier ; Bézier curve oscillator ; bezier approximation of sin function
Bezier.ar(
	freq: 440,
	phase: 0,
	param: [0, 0, 0.2, -1.3, 0.3, -1.3, 0.5, 0, 0.7, 1.3, 0.8, 1.3, 1, 0]
) * 0.1

// Bezier ; mouse control of frequency
var x = MouseX.kr(minval: 40, maxval: 4000, warp: 'exponential', lag: 0.2);
Bezier.ar(
	freq: x,
	phase: 0,
	param: [0, 0, 0.2, -1.3, 0.3, -1.3, 0.5, 0, 0.7, 1.3, 0.8, 1.3, 1, 0]
) * 0.1

// Bezier ; mouse control of frequency & one control point
var x = MouseX.kr(minval: 40, maxval: 4000, warp: 'exponential', lag: 0.2);
var y = MouseY.kr(minval: 0.1, maxval: 0.2, warp: 'linear', lag: 0.2);
Bezier.ar(
	freq: x,
	phase: 0,
	param: [0, 0, y, -1.3, 0.3, -1.3, 0.5, 0, 0.7, 1.3, 0.8, 1.3, 1, 0]
) * 0.1

// Bezier ; dynamic shifting of control points, as oscillator
var w = { | l r |
	LFDNoise3.ar(freq: 2).range(lo: l, hi: r)
};
var f = {
	var p = [
		0, 0,
		w.value(0.05, 0.25), -1.3,
		w.value(0.25, 0.45), -1.3,
		0.5, 0,
		w.value(0.55, 0.75), 1.3,
		w.value(0.75, 0.95), 1.3,
		1, 0
	];
	var o = Bezier.ar(freq: w.value(200, 205), phase: 0, param: p);
	Pan2.ar(in: o, pos: IRand.new(lo: -1, hi: 1), level: 0.1)
};
f !+ 4

// Bezier ; event control
var voiceFunc = { | e |
    var w = { | l r |
        LFDNoise3.ar(freq: e.j * 5).range(lo: l, hi: r)
    };
    {
        var p = [
			0, 0,
			w.value(0.05, 0.25), -1.3,
			w.value(0.25, 0.45), -1.3,
			0.5, 0,
			w.value(0.55, 0.75), 1.3,
			w.value(0.75, 0.95), 1.3,
			1, 0
		];
        var o = Bezier.ar(freq: w.value(200, 205) * (e.x + 0.5), phase: 0, param: p);
        Pan2.ar(in: o, pos: e.i * 2 - 1, level: e.z * LagUD.kr(in: e.w, lagTimeU: 0.01, lagTimeD: e.y * 4))
    } !+ 4
};
Voicer.ar(numVoices: 4, voiceFunc: voiceFunc).sum

//---- ui
ContinuousEventUi.new(frameRate: 20, areaWidth: 230, areaHeight: 130, areaScaling: 2.5, gridFileName: nil).makeWindow;
