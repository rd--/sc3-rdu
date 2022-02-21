// rdx7 ; event control ; data at local buffer
var voiceData = [
    [25, 21, 98, 38, 99,  0, 99,  0, 36, 17, 87,  2,  1, 0, 0, 0, 59,  0,  1, 1, 8],
    [66, 69, 60, 35,  0,  0, 98,  0,  0,  0,  4,  0,  0, 0, 0, 1, 90,  0,  1, 0, 8],
    [25, 21, 98, 38, 99,  0, 99,  2, 35, 15, 79,  3,  1, 1, 0, 0, 91,  1,  0, 0, 6],
    [97, 69, 60, 35, 99, 91, 98,  0,  0,  0,  0,  0,  0, 0, 0, 1, 68,  0, 22, 0, 7],
    [78, 63, 53, 28, 99, 52, 62,  3, 38, 11, 80,  3,  0, 0, 0, 0, 77,  0,  7, 0, 0],
    [98, 56, 63, 23, 99, 89, 74,  2,  0,  4,  1,  0,  0, 0, 0, 0, 99,  0,  1, 0, 7],
    [99, 99, 99, 99, 50, 50, 50, 50,  3,  2,  1, 29, 99, 1, 0, 0,  0,  1, 24] ];
var voiceFunc = {
    arg e;
    var x0 = Latch.kr(in: e.x, trig: e.w);
    var buf = LocalBuf.newFrom(voiceData.flatten);
    var dx7 = RDX7.ar(bufnum: buf, on: e.w, off: 0, data: 0, vc: 0, mnn: e.p * 127, vel: e.z, pw: (0x2000 * (e.x - x0)), mw: 0, bc: 0, fc: 0);
    Pan2.ar(in: dx7, pos: (e.o * 2 - 1), level: e.z) };
Mix.ar(Voicer.ar(numVoices: 16, voiceFunc: voiceFunc))

//---- ui
REventUI.new(frameRate: 25, areaWidth: 230, areaHeight: 130, areaScaling: 2.5, gridFileName: nil, deriveXFromP: true).makeWindow;

//---- event/routine control ; event pattern ; c.f. CmdPeriod.freeServers or R.cmdPeriodRetainServerState
Pbind(
    \p, Pwhite([3, 4, 7], 8) * 12 + Pwrand([0, 1, 2, 3, 4, 5], [2, 1, 2, 3, 1, 2].normalizeSum, inf).degreeToKey(Scale.yu(\pythagorean)),
    \y, Pbrown([0, 0.5], [0.5, 1]),
    \z, Pbrown(0.05, 0.25),
    \o, Pwhite(),
    \dur, Pwrand([0.1, 0.2, 0.3, 0.4, 0.6], [16, 8, 4, 2, 1].normalizeSum, inf)).re(16)

//---- event/routine control ; event function
{ (p: {36 + 48.rand}.dup(5.rand + 1), x: 1.0.rand, y: 1.0.rand, z: 0.25.rand, o: 1.0.rand, dur: 1.0.rand) }.re(16)

//---- event/routine control ; event pattern
Pbind(
    \p, Pwhite([4, 6, 7], 7) * 12 + Pbrown(0,5).degreeToKey(Scale.yu(\pythagorean)),
    \y, Pbrown(),
    \z, Pbrown(0, 0.2),
    \o, Pbrown(),
    \dur, Pbrown(0.05, 0.15)).re(16)

//---- midi control ; make graph and add synthdef, voice data at local buffer
(var vc =
  [[25,21,98,38,99, 0,99, 0,36,17,87,2,1,0,0,0,59, 0, 1,1,8]
  ,[66,69,60,35, 0, 0,98, 0, 0, 0, 4,0,0,0,0,1,90, 0, 1,0,8]
  ,[25,21,98,38,99, 0,99, 2,35,15,79,3,1,1,0,0,91, 1, 0,0,6]
  ,[97,69,60,35,99,91,98, 0, 0, 0, 0,0,0,0,0,1,68, 0,22,0,7]
  ,[78,63,53,28,99,52,62, 3,38,11,80,3,0,0,0,0,77, 0, 7,0,0]
  ,[98,56,63,23,99,89,74, 2, 0, 4, 1,0,0,0,0,0,99, 0, 1,0,7]
  ,[99,99,99,99,50,50,50,50,3,2,1,29,99,1,0,0,0,1,24]]
;var gr =
  {arg bus=0,gate=1,reset=0,data=0,prg=0,mnn=60,vel=99,pw=0,mw=0,bc=0,fc=0,pan=0,vol=1
  ;var buf = newFrom(LocalBuf,flatten(vc))
  ;var sig = ar(RDX7,buf,gate,reset,data,prg,mnn,vel,pw,mw,bc,fc)
  ;ar(DetectSilence,sig,0.001,0.1,1) /*mrg*/
  ;ar(Out,bus,ar(Pan2,sig,pan,vol))}
;var sy = new(SynthDef,"rdx7-vc-gt",gr)
;add(sy))

// setup midi (if required)
connectAll(MIDIIn)

// simple note on/off listeners, no voice logic, w/ tuning table
(var syn = "rdx7-vc-gt"
;var mem = newClear(Array,128)
;var scl = semitones(chromatic(Scale,at(Tuning,\mean4)))
;var tun = flatten(collect(series(0,12,120),{arg n; n + scl}))
;noteOn(MIDIFunc,
  {arg vel,mnn,ch,src
  ;var nid = alloc(nodeAllocator(s))
  ;put(mem,mnn,nid)
  ;postln(["note-on",mnn,vel,nid,at(tun,mnn) - mnn])
  ;sendMsg(s,"/s_new",syn,nid,0,1,"mnn",at(tun,mnn),"vel",vel,"gate",1)},nil,0)
;noteOff(MIDIFunc,
  {arg vel,mnn,ch,src
  ;var nid = at(mem,mnn)
  ;postln(["note-off",mnn,vel,nid])
  ;sendMsg(s,"/n_set",nid,"gate",0)},nil,0))

// cleanup
run(CmdPeriod)

//----
Server.default.dumpOSC(1)
CmdPeriod.freeServers = false
REvent.new.initialize