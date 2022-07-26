LagC : PureUGen {
    *kr {
        arg in=0.0, timeUp=0.1, curveUp=0.0, timeDown=0.1, curveDown=0.0;
        ^this.multiNew('control', in, timeUp, curveUp, timeDown, curveDown);
    }
}
