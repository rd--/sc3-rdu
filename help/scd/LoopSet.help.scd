// LoopSet ; two sets of two loops ; whole and center half ; requires=buf
var buf = 10;
var i = BufRateScale.kr(buf) * [2/3, 1];
LoopSet.ar(buf, 0, 1, 0.1, i, [0, 1, 1, 1, 1/4, 3/4, 2, 1/2])

// LoopSet - random loops
var buf = 10;
var n = 24;
var i = BufRateScale.kr(buf) * [1, 4/5];
var f = {
	var left = 1.0.rand;
	var right = left + (1.0 - left).rand;
	[left, right, (12/n).rand, 0.166 + 0.166.rand]
};
var a = (f ! n).flatten;
LoopSet.ar(buf, 0, 0.1, [1, 3/2], i, a)

//---- ; load buffer
f = Platform.systemAppSupportDir +/+ "sounds/a11wlk01.wav";
s.sendMsg("/b_allocRead", 10, f, 0, -1);

//---- ; notes ; Concurrent loops at a signal buffer

Create a set of concurrent loops at a signal buffer.  This is the
static and composed variant of Freezer.  There are five global
inputs, the buffer and then: left, right, gain and increment.  The
first two are initialization rate, the second two control rate.
Each loop is defined by a quadruple: left, right, gain and
increment.  The left and right values are in the range [0, 1) and
refer to the segment of the buffer established by the group left
and right values, which are in the range [0, 1) in relation to the
signal buffer.

Buffer Left                                  Buffer Right
|                                                       |
|      Group Left              Group Right              |
|      |                                 |              |
|------|----|-----------------------|----|--------------|
            |                       |
            Loop Left      Loop Right
