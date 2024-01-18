// TScramble ; octaves, swaps channels on impulse, scramble may be identity ; audio rate
var tr = Impulse.ar(1, 0);
SinOsc.ar(TScramble.ar(tr, [222, 444]), 0) * 0.1

// TScramble ; c-major sin tones across stereo field, scrambles on impulse ; audio rate
var tr = Impulse.ar(1, 0);
Splay.ar(SinOsc.ar(TScramble.ar(tr, [60, 62, 64, 65, 67, 69, 71, 72].midicps), 0)) * 0.1

// TScramble ; c-major sin tones across stereo field, scrambles on impulse ; control rate
var tr = Impulse.kr(1, 0);
Splay.ar(SinOsc.ar(TScramble.kr(tr, [60, 62, 64, 65, 67, 69, 71, 72].midicps), 0)) * 0.1

// TScramble ; initially unscrambled
var tr = Dust.kr(1);
Splay.ar(SinOsc.ar(TScramble.kr(tr, [60, 62, 64, 65, 67, 69, 71, 72].midicps), 0)) * 0.1

// TScramble ; reference
Splay.ar(SinOsc.ar([60, 62, 64, 65, 67, 69, 71, 72].midicps, 0)) * 0.1
