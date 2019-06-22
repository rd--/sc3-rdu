// load audio
b = read(Buffer,s,systemAppSupportDir(Platform) +/+ "sounds/a11wlk01.wav");

// two sets of two loops over whole buffer at unary gain and at two
// thirds and unary increment, one loop of each set is over the middle
// of buffer at half increment and double gain
{var i = kr(BufRateScale,bufnum(b)) * [2/3,1]
;ar(Out,0,ar(RLoopSet,bufnum(b),0,1,0.1,i,[0,1,1,1,1/4,3/4,2,1/2]))}.play

// some random loops...
{var n = 24
;var i = kr(BufRateScale,bufnum(b)) * [1,4/5]
;var f = {var left = rand(1.0)
         ;var right = left + rand(1.0 - left)
         ;[left,right,rand(12/n),0.166 + rand(0.166)]}
;var a = flatten(fill(Array,n,f))
;ar(Out,0,ar(RLoopSet,bufnum(b),0,0.1,[1,3/2],i,a))}.play

// free buffer
free(b)
