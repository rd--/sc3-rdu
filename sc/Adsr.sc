Adsr {
    *new {
        arg gate = 1, attackTime = 0.01, decayTime = 0.3, sustainLevel = 0.5, releaseTime = 1, curves = -4;
        ^EnvGen.ar(Env.adsr(attackTime, decayTime, sustainLevel, releaseTime, 1, curves), gate, 1, 0, 1, 0)
    }
}
