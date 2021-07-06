RDX7 : PureUGen {
    *ar { arg bufnum=0, on=0, off=0, data=0, vc=0, mnn=60, vel=99, pw=0, mw=0, bc=0, fc=0;
        ^this.multiNew('audio', bufnum, on, off, data, vc, mnn, vel, pw, mw, bc, fc);
    }
}
