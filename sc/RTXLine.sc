RTXLine : UGen {
  *kr { arg start = 0.0, end = 1.0, dur = 10, trig = 0;
    ^LinExp.kr(in: Sweep.kr(trig: trig, rate: 1 / dur), srclo: 0, srchi: 1, dstlo: start, dsthi: end)
  }
}
