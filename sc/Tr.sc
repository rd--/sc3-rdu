Tr {
    *kr { arg tr; ^Trig.kr(tr, ControlDur.ir()) }
    *ar { arg tr; ^Trig.ar(tr, SampleDur.ir() * 2) }
    *new { arg tr; ^this.performList(tr.rate.rateToSelector, [tr]) }
}
