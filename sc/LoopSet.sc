LoopSet : PureUGen { // not Filter because input is not at argument zero
    *ar {
        arg  bufnum = 0.0, left = 0.0, right = 1.0, gain = 1.0, increment = 1.0, spec;
        ^this.multiNewList(['audio', bufnum, left, right, gain, increment] ++ spec);
    }
}
