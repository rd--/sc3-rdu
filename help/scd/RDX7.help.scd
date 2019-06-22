// make graph and add synthdef, voice data is at local buffer
{var vc = [[25,21,98,38,99, 0,99, 0,36,17,87,2,1,0,0,0,59,0, 1,1,8]
          ,[66,69,60,35, 0, 0,98, 0, 0, 0, 4,0,0,0,0,1,90,0, 1,0,8]
          ,[25,21,98,38,99, 0,99, 2,35,15,79,3,1,1,0,0,91,1, 0,0,6]
          ,[97,69,60,35,99,91,98, 0, 0, 0, 0,0,0,0,0,1,68,0,22,0,7]
          ,[78,63,53,28,99,52,62, 3,38,11,80,3,0,0,0,0,77,0, 7,0,0]
          ,[98,56,63,23,99,89,74, 2, 0, 4, 1,0,0,0,0,0,99,0, 1,0,7]
          ,[99,99,99,99,50,50,50,50,3,2,1,29,99,1,0,0,0,1,24]].flatten
;var gr =
  {arg bus=0,gate=1,reset=0,data=0,prg=0,mnn=60,vel=99,pw=0,mw=0,bc=0,fc=0,pan=0,vol=1
  ;var buf = LocalBuf.newFrom(vc)
  ;var sig = RDX7.ar(buf,gate,reset,data,prg,mnn,vel,pw,mw,bc,fc)
  ;DetectSilence.ar(sig,0.001,0.1,1)
  ;Out.ar(bus,Pan2.ar(sig,pan,vol))}
;var sy = SynthDef("rdx7-vc-gt",gr)
;sy.add}.()

// setup midi if required
MIDIIn.connectAll;

// simple note on/off listeners, no voice logic
{var syn = "rdx7-vc-gt"
;var mem = Array.newClear(128)
;var note_on = MIDIFunc.noteOn(
  {arg vel, mnn, ch, src
  ;var nid = s.nodeAllocator.alloc
  ;mem.put(mnn,nid)
  ;[mnn,vel,nid].postln
  ;s.sendMsg("/s_new", syn, nid, 0, 1, "mnn", mnn, "vel", vel, "gate", 1)},nil,0)
;var note_off = MIDIFunc.noteOff(
  {arg vel, mnn, ch, src
  ;var nid = mem.at(mnn)
  ;[mnn,vel,nid].postln
  ;s.sendMsg("/n_set", nid, "gate", 0)},nil,0)
;/*env*/ x = [note_on,note_off]
}.()

// cleanup
/*env*/ x.collect({arg m; m.free});
