// Load audio
b = Buffer.read(s,Platform.systemAppSupportDir +/+ "sounds/a11wlk01.wav");

// Two sets of two loops over whole buffer at unary gain and at two
// thirds and unary increment, one loop of each set is over the middle
// of buffer at half increment and double gain.
{var i = BufRateScale.kr(b.bufnum) * [2/3,1]
;Out.ar(0,RLoopSet.ar(b.bufnum,0,1,0.1,i,[0,1,1,1,1/4,3/4,2,1/2]))}.play

// Some random loops...
{var n = 24
;var i = BufRateScale.kr(b.bufnum) * [1,4/5]
;var f = {var left = 1.0.rand
         ;var right = left + (1.0-left).rand
         ;[left,right,(12/n).rand,0.166 + 0.166.rand];}
;var a = Array.fill(n,f).flatten
;Out.ar(0,RLoopSet.ar(b.bufnum,0,0.1,[1,3/2],i,a))}.play

// Free buffer
b.free
