MultiTapDelay {

    *ar {
        arg timesArray, levelsArray, in;
        var delayFrames = timesArray.maxItem * Server.default.sampleRate;
        var buf = BufAlloc(in.asArray.size, delayFrames).clearBuf;
        ^MultiTap.ar(timesArray, levelsArray, in, 1, 0, buf)
        /*
        var writer = DelayWrite(buf, in);
        var numReaders = timesArray.size;
        var readers = 1.to(numReaders).collect({ arg item; DelayTap(buf, timesArray.nth(item)) * levelsArray.nth(item) });
        ^readers.mrg(writer).sum
        */
    }

    *new {
        arg timesArray, levelsArray, in;
        ^this.ar(timesArray, levelsArray, in)
    }
}
