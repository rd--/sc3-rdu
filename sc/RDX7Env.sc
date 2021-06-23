RDX7Env : UGen {
  *ar {
    arg gate, data, r1, r2, r3, r4, l1, l2, l3, l4, ol;
    ^this.multiNew('audio',gate, data, r1, r2, r3, r4, l1, l2, l3, l4, ol)
  }
}
