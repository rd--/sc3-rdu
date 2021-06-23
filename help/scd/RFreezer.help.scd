// RFreezer
{arg out=0,buf=10,left=0,right=1,gain=1,incr=1,incrOff=0,incrRand=0,rightRand=0,phaseSync=0,phaseRand=0,numLp=4
;RFreezer.ar(buf,left,right,gain,[incr,incr + 0.01],incrOff,incrRand,rightRand,phaseSync,phaseRand,numLp) * 0.1}

// RFreezer ; event control
{var voiceFunc =
 {arg e
 ;var out=0,buf=10,left=0,right=1,gain=1,incr=1,incrOff=0,incrRand=0,rightRand=0.1,phaseSync=0,phaseRand=1,numLp=4
 ;RFreezer.ar(buf,e.x * 0.75,e.x * (0.75 + (e.y * 0.1)),e.y,[incr * (1 - e.z),incr * (1 - e.rx)],incrOff,incrRand,rightRand + (e.y * 0.1),phaseSync,phaseRand,numLp) * e.z * e.w}
;Mix.ar(REvent.voicer(numVoices: 16, voiceFunc: voiceFunc))}

//---- allocate signal buffer.
sendMsg(s,"/b_allocRead",10,Platform.systemAppSupportDir +/+ "sounds/a11wlk01.wav",0,-1)

// instrument definition
add(new(SynthDef,"RFreezer",
{arg out=0,bufnum=0,left=0,right=1,gain=1,incr=1
    ,incrOff=0,incrRand=0,rightRand=0,phaseSync=0,phaseRand=0,numLp=4
;ar(Out,out,ar(RFreezer,bufnum,left,right,gain,[incr,incr + 0.01]
              ,incrOff,incrRand,rightRand,phaseSync,phaseRand,numLp))}))

// mouse{xy} controller definitions
add(new(SynthDef,"MouseControl",
{var size = kr(MouseY,0.05,0.95)
;var left = kr(MouseX,0,1) * (1.0 - size)
;kr(Out,32,max(left,0.0))
;kr(Out,33,min(left + size,1.0))}))

// put default values onto control busses and start instrument
sendMsg(s,"/c_setn",32,10,0.3,0.4,0.36,0.35,0.02,0.003,0.34,-0.5,-0.5,6);
sendMsg(s,"/s_new","RFreezer",1003,1,0,"bufnum",10,"gain",0.1);
sendMsg(s,"/n_mapn",1003,2,32,10);
sendMsg(s,"/s_new","MouseControl",1004,1,0);

// Free nodes and buffer.
sendMsg(s,"/n_free",1003);
sendMsg(s,"/n_free",1004);
sendMsg(s,"/b_free",10);
