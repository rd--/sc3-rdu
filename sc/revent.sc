REventParam {
    var <>g,<>x,<>y,<>z,<>o,<>rx,<>ry,<>p;

    init {
        arg paramArray;
        g = paramArray[0];
        x = paramArray[1];
        y = paramArray[2];
        z = paramArray[3];
        o = paramArray[4];
        rx = paramArray[5];
        ry = paramArray[6];
        p = paramArray[7];
    }

    *new {
        arg paramArray;
        ^super.new.init(paramArray);
    }

}

REventAddr {
    *kr {
        arg k0 = 13000, c = 0;
        ^REventParam.new(In.kr(bus: k0 + (c * 10), numChannels: 8));
    }
}

REventVoicerAddr {
    *new {
        arg k0 = 13000, c0 = 0, numVoices = 16, voiceFunc;
        ^(0 .. numVoices - 1).collect({arg c; voiceFunc.value(REventAddr.kr(k0: k0, c: (c0 + c)),c)});
    }
}

REvent {
    *kr {
        arg numVoices = 16, voiceFunc;
        var k0 = NamedControl.kr("EventAddr",13000);
        var c0 = NamedControl.kr("EventZero",0);
        ^REventAddr.kr(k0: k0, c0: c0, numVoices: numVoices, voiceFunc: voiceFunc);
    }
}

REventVoicer {
    *new {
        arg numVoices = 16, voiceFunc;
        var k0 = NamedControl.kr("EventAddr",13000);
        var c0 = NamedControl.kr("EventZero",0);
        ^REventVoicerAddr.new(k0: k0, c0: c0, numVoices: numVoices, voiceFunc: voiceFunc)
    }
}
