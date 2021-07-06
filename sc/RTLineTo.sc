RTLineTo {
    *kr {
        arg endFunc = nil, dur = 10, trig = 0;
        var l1 = endFunc.value(TDelay.kr(trig, ControlDur.ir));
        var l0 = Latch.kr(l1, trig);
        ^RTLine.kr(l0, l1, dur, trig);
    }
}
