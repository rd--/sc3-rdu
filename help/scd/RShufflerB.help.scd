// Allocate buffer.
f = Platform.systemAppSupportDir +/+ "sounds/a11wlk01.wav";
s.sendMsg("/b_allocRead", 10, f, 0, -1);

// Static (parameter)
{var s = RShufflerB.ar(10,0,0.05,0.95,1.05,0.035,0.050,0.1,0.2,0.4,0.6,0.4,0.6,0,1,0.005,0.010,1,0,0)
;Out.ar(0,s)}.play

// Instrument
SynthDef("RShufflerB",{
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
  Out.ar(out, gain * sh)}).add;

// Start instrument, put defaults onto control busses and map node to use them.
s.sendMsg("/s_new", "RShufflerB", 1001, 1, 0, "bufnum", 10);
s.sendMsg("/c_setn", 0, 20, 0.083808, 0.152608, 0.20857142857142857, 0.4136507936507936, 1/45, 11/105, 16/63, 142/315, 128/315, 47/315, 17/105, 136/315, 1/21, 55/63, 8/315, 37/315, 0, 0, 0, 622/315);
s.sendMsg("/n_mapn", 1001, 2, 0, 20);

// De-allocate node and buffer
s.sendMsg("/n_free", 1001);
s.sendMsg("/b_free", 10);

// sc3-ctl...

RGUI.midiInit;

(
c = RCtlSet(server: s, opt: (rows: 20, columns: 1, rowHeight: 35, concise: false, vspace: 2));
c[0].setup("bufnum",ControlSpec.new(0.0000, 100.0000, LinearWarp, 1.0000, 0.0000),0.0000,0);
c[1].setup("readLocationMinima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.0000),0.0000,1);
c[2].setup("readLocationMaxima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.0000),0.0000,2);
c[3].setup("readIncrementMinima",ControlSpec.new(0.5000, 2.0000, LinearWarp, 0.0100, 1.0000),1.0000,3);
c[4].setup("readIncrementMaxima",ControlSpec.new(0.5000, 2.0000, LinearWarp, 0.0100, 1.0000),1.0000,4);
c[5].setup("durationMinima",ControlSpec.new(0.0010, 0.5000, LinearWarp, 0.0050, 0.0050),0.0050,5);
c[6].setup("durationMaxima",ControlSpec.new(0.0010, 0.5000, LinearWarp, 0.0050, 0.5000),0.5000,6);
c[7].setup("envelopeAmplitudeMinima",ControlSpec.new(0.0500, 1.0000, ExponentialWarp, 0.0100, 0.5000),0.5000,7);
c[8].setup("envelopeAmplitudeMaxima",ControlSpec.new(0.0500, 1.0000, ExponentialWarp, 0.0100, 0.5000),0.5000,8);
c[9].setup("envelopeShapeMinima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.5000),0.5000,9);
c[10].setup("envelopeShapeMaxima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.5000),0.5000,10);
c[11].setup("envelopeSkewMinima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.5000),0.5000,11);
c[12].setup("envelopeSkewMaxima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.5000),0.5000,12);
c[13].setup("stereoLocationMinima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 0.0000),0.0000,13);
c[14].setup("stereoLocationMaxima",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 1.0000),1.0000,14);
c[15].setup("interOffsetTimeMinima",ControlSpec.new(0.0050, 0.5000, LinearWarp, 0.0050, 0.0500),0.0500,15);
c[16].setup("interOffsetTimeMaxima",ControlSpec.new(0.0010, 0.5000, LinearWarp, 0.0050, 0.0500),0.0500,16);
c[17].setup("ftableReadLocationIncrement",ControlSpec.new(0.0000, 1.0000, LinearWarp, 0.0100, 1.0000),1.0000,17);
c[18].setup("readIncrementQuanta",ControlSpec.new(0.0000, 0.5000, LinearWarp, 0.0100, 0.0000),0.0000,18);
c[19].setup("interOffsetTimeQuanta",ControlSpec.new(0.0000, 0.0100, LinearWarp, 0.0001, 0.0000),0.0000,19);
)
