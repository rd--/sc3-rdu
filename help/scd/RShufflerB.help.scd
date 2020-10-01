// allocate buffer
f = Platform.systemAppSupportDir +/+ "sounds/a11wlk01.wav";
s.sendMsg("/b_allocRead", 10, f, 0, -1);

// static (parameter)
{var s = RShufflerB.ar(10,0,0.05,0.95,1.05,0.035,0.050,0.1,0.2,0.4,0.6,0.4,0.6,0,1,0.005,0.010,1,0,0)
;Out.ar(0,s)}.play

// instrument
d = SynthDef("RShufflerB",{
   arg out=0,
       bufnum=0.0,
       readLocationMinima=0.01,
       readLocationMaxima=0.02,
       readIncrementMinima=1.0,
       readIncrementMaxima=1.0,
       durationMinima=0.2,
       durationMaxima=0.2,
       envelopeAmplitudeMinima=0.5,
       envelopeAmplitudeMaxima=0.5,
       envelopeShapeMinima=0.5,
       envelopeShapeMaxima=0.5,
       envelopeSkewMinima=0.5,
       envelopeSkewMaxima=0.5,
       stereoLocationMinima=0.5,
       stereoLocationMaxima=0.5,
       interOffsetTimeMinima=0.05,
       interOffsetTimeMaxima=0.1,
       ftableReadLocationIncrement=1.0,
       readIncrementQuanta=0,
       interOffsetTimeQuanta=0,
       gain=1;
   var sh = RShufflerB.ar(bufnum,
                          readLocationMinima, readLocationMaxima,
                          readIncrementMinima, readIncrementMaxima,
                          durationMinima, durationMaxima,
                          envelopeAmplitudeMinima, envelopeAmplitudeMaxima,
                          envelopeShapeMinima, envelopeShapeMaxima,
                          envelopeSkewMinima, envelopeSkewMaxima,
                          stereoLocationMinima, stereoLocationMaxima,
                          interOffsetTimeMinima, interOffsetTimeMaxima,
                          ftableReadLocationIncrement,
                          readIncrementQuanta,
                          interOffsetTimeQuanta);
  Out.ar(out, gain * sh)});
d.add;

// start instrument, put defaults onto control busses and map node to use them
s.sendMsg("/s_new", "RShufflerB", 1001, 1, 0, "bufnum", 10);
s.sendMsg("/c_setn", 0, 22, 0, 10, 0.083808, 0.152608, 0.20857142857142857, 0.4136507936507936, 1/45, 11/105, 16/63, 142/315, 128/315, 47/315, 17/105, 136/315, 1/21, 55/63, 8/315, 37/315, 0, 0, 0, 622/315);
s.sendMsg("/n_mapn", 1001, 0, 0, 22);

// de-allocate node and buffer
s.sendMsg("/n_free", 1001);
s.sendMsg("/b_free", 10);

// param (name,control-spec,default-value)
p =
 [//["out",ControlSpec.new(0.0000, 100.0000, LinearWarp, 1.0000, 0.0000),0.0000],
  //["bufnum",ControlSpec.new(0.0000, 100.0000, LinearWarp, 1.0000, 0.0000),0.0000],
  ["readLocationMinima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.0000),0.0000],
  ["readLocationMaxima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.0000),0.0000],
  ["readIncrementMinima",ControlSpec.new(0.5000, 2.0000, LinearWarp, 0.0100, 1.0000),1.0000],
  ["readIncrementMaxima",ControlSpec.new(0.5000.00, 2.0000, LinearWarp, 0.0100, 1.0000),1.0000],
  ["durationMinima",ControlSpec.new(0.0010, 0.5000, LinearWarp, 0.0050, 0.0050),0.0050],
  ["durationMaxima",ControlSpec.new(0.0010, 0.5000, LinearWarp, 0.0050, 0.5000),0.5000],
  ["envelopeAmplitudeMinima",ControlSpec.new(0.0500, 1.0000, ExponentialWarp, 0.0100, 0.5000),0.5000],
  ["envelopeAmplitudeMaxima",ControlSpec.new(0.0500, 1.0000, ExponentialWarp, 0.0100, 0.5000),0.5000],
  ["envelopeShapeMinima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.5000),0.5000],
  ["envelopeShapeMaxima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.5000),0.5000],
  ["envelopeSkewMinima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.5000),0.5000],
  ["envelopeSkewMaxima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.5000),0.5000],
  ["stereoLocationMinima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.0000),0.0000],
  ["stereoLocationMaxima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 1.0000),1.0000],
  ["interOffsetTimeMinima",ControlSpec.new(0.0050, 0.5000, LinearWarp, 0.0050, 0.0500),0.0500],
  ["interOffsetTimeMaxima",ControlSpec.new(0.0010, 0.5000, LinearWarp, 0.0050, 0.0500),0.0500],
  ["ftableReadLocationIncrement",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 1.0000),1.0000],
  ["readIncrementQuanta",ControlSpec.new(0.0000, 0.5000, LinearWarp, 0.0100, 0.0000),0.0000],
  ["interOffsetTimeQuanta",ControlSpec.new(0.0000, 0.0100, LinearWarp, 0.0001, 0.0000),0.0000],
  ["gain",ControlSpec.new(0.0100, 1.0000, ExponentialWarp, 0.0001, 0.5000),0.0000]];

// ndef
Ndef(\z,d.func).set(\bufnum, 10).play;
p.do({arg x; Ndef(\z).addSpec(x[0].asSymbol,x[1])});
Ndef(\z).gui;
ProxyPresetGui(NdefPreset(\z)); // a nil spec for bufnum stops [rand] from editing it
Ndef(\z).clear;

// sc3-ctl...
RGUI.midiInit;
c = RCtlSet(server: s, opt: (rows: p.size, columns: 1, rowHeight: 35, concise: false, vspace: 2));
p.do({arg x, i; c[i].setup(x[0],x[1],x[2],i)});
