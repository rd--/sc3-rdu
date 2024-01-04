// SamplerIndex ; event control ; stereo ; requires loaded bosendorfer (or equivalent) sample data
var b0 = NamedControl.kr("b0", 0);
var voiceFunc = { |e|
    var seq = [
        21, 23, 24, 26, 28, 29, 31, 33, 35, 36, 38, 40, 41, 43, 45, 47, 48, 50, 52, 53, 55, 57, 59,
        60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79, 81, 83, 84, 86, 88, 89, 91, 93, 95, 96, 98,
        100, 101, 103, 105, 107, 108
    ];
    var tbl = LocalBuf.newFrom(seq);
    var mnn = e.x * 88 + 21;
    var mnn0 = Latch.kr(mnn, e.w);
    var rt = ((mnn - mnn0) * e.y).midiratio;
    var idx = SamplerIndex.kr(tbl, BufFrames.kr(tbl), mnn0);
    var b1 = b0 + idx.at(0);
    var sig = PlayBuf.ar(2, b1, BufRateScale.kr(b1) * idx.at(1) * rt, e.w, 0, 0, 0);
    sig * e.z * LagUD.kr(e.w, 0, 4)
};
Voicer.ar(part: 0, numVoices: 16, voiceFunc: voiceFunc).sum
