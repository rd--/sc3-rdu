// RLoopSet - two sets of two loops over whole buffer at unary gain
// and at two thirds and unary increment, one loop of each set is over
// the middle of buffer at half increment and double gain
{arg buf = 0
;var i = kr(BufRateScale,buf) * [2/3,1]
;ar(RLoopSet,buf,0,1,0.1,i,[0,1,1,1,1/4,3/4,2,1/2])}

// RLoopSet - random loops
{arg buf = 0
;var n = 24
;var i = kr(BufRateScale,buf) * [1,4/5]
;var f = {var left = rand(1.0)
         ;var right = left + rand(1.0 - left)
         ;[left,right,rand(12/n),0.166 + rand(0.166)]}
;var a = flatten(fill(Array,n,f))
;ar(RLoopSet,buf,0,0.1,[1,3/2],i,a)}
