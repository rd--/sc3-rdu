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
       locL=0.01,
       locR=0.02,
       incrL=1.0,
       incrR=1.0,
       durL=100.0, /* ms */
       durR=200.0,
       ampL=0.5,
       ampR=0.5,
       shapeL=0.5,
       shapeR=0.5,
       skewL=0.5,
       skewR=0.5,
       panL=0.5,
       panR=0.5,
       iotL=5.0, /* ms */
       iotR=10.0,
       bufIncr=1.0,
       incrQ=0,
       iotQ=0,
       gain=1;
   var sh = RShufflerB.ar(bufnum,
                          locL, locR,
                          incrL, incrR,
                          durL * 0.001, durR * 0.001,
                          ampL, ampR,
                          shapeL, shapeR,
                          skewL, skewR,
                          panL, panR,
                          iotL * 0.001, iotR * 0.001,
                          bufIncr,
                          incrQ,
                          iotQ);
  Out.ar(out, gain * sh)});
d.add;

// start instrument, put defaults onto control busses and map node to use them
s.sendMsg("/s_new", "RShufflerB", 1001, 1, 0, "bufnum", 10);
s.sendMsg("/c_setn", 0, 22, 0, 10, 0.083808, 0.152608, 0.20857142857142857, 0.4136507936507936, 1/45, 11/105, 16/63, 142/315, 128/315, 47/315, 17/105, 136/315, 1/21, 55/63, 8/315, 37/315, 0, 0, 0, 622/315);
s.sendMsg("/n_mapn", 1001, 0, 0, 22);

// de-allocate node and buffer
s.sendMsg("/n_free", 1001);
s.sendMsg("/b_free", 10);

// param (name,control-spec=min,max,warp,step,default)
p =
 [["out",ControlSpec.new(0.0000, 7.0000, LinearWarp, 1.0000, 0.0000)],
  ["bufnum",ControlSpec.new(10.0000, 10.5000, LinearWarp, 1.0000, 10.0000)], // ndef...
  ["locL",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.0000)],
  ["locR",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.0000)],
  ["incrL",ControlSpec.new(0.5000, 2.0000, LinearWarp, 0.0100, 1.0000)],
  ["incrR",ControlSpec.new(0.5000, 2.0000, LinearWarp, 0.0100, 1.0000)],
  ["durL",ControlSpec.new(0.1000, 1000.0000, 6, 0.0100, 50.0000)],
  ["durR",ControlSpec.new(0.1000, 1000.0000, 6, 0.0100, 50.0000)],
  ["ampL",ControlSpec.new(0.0500, 1.0000, FaderWarp, 0.0100, 0.5000)],
  ["ampR",ControlSpec.new(0.0500, 1.0000, FaderWarp, 0.0100, 0.5000)],
  ["shapeL",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.5000)],
  ["shapeR",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.5000)],
  ["skewL",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.5000)],
  ["skewR",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.5000)],
  ["panL",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.0000)],
  ["panR",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 1.0000)],
  ["iotL",ControlSpec.new(0.5000, 500.0000, 6, 0.0100, 5.0000)],
  ["iotR",ControlSpec.new(0.5000, 500.0000, 6, 0.0100, 10.0000)],
  ["bufIncr",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 1.0000)],
  ["incrQ",ControlSpec.new(0.0000, 0.5000, LinearWarp, 0.0100, 0.0000)],
  ["iotQ",ControlSpec.new(0.0000, 0.0100, LinearWarp, 0.0001, 0.0000)],
  ["gain",ControlSpec.new(0.0100, 1.0000, FaderWarp, 0.0001, 0.1000)]];

// ndef
Ndef(\z,d.func).set(\bufnum, 10).play;
p.do({arg x; Ndef(\z).addSpec(x[0].asSymbol,x[1])});
Ndef(\z).gui;
ProxyPresetGui(NdefPreset(\z));
Ndef(\z).clear;

// sc3-ctl...
RGUI.midiInit;
c = RCtlSet(server: s, opt: (rows: 3, columns: 8));
p.do({arg x, i; c[i].setup(x[0],x[1],x[2],i)});
