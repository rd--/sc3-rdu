RDelaySet : UGen {
  *ar { arg in = 0.0, spec;
    ^this.multiNewList(['audio', in] ++ spec);
  }
}
