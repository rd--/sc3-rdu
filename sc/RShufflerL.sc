RShufflerL : Filter {
    *ar {
        arg in = 0.0, fragmentSize = 0.01, maxDelay = 0.01, mul = 1.0, add = 0.0;
        ^this.multiNew('audio', in, fragmentSize, maxDelay).madd(mul, add);
    }
}
