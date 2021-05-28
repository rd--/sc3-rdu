TXLine : UGen {
  *kr { arg start = 0.0, end = 1.0, dur = 10, trig = 0;
      var env = Env.new(levels: [0, start, end], times: [0, dur], curve: [\exp]);
      ^EnvGen.kr(envelope: env, gate: trig);
  }
}
