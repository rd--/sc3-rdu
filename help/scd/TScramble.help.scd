// TScramble - octaves, swaps channels on impulse, scramble may be identity
var tr = Impulse.kr(1, 0);
SinOsc.ar(TScramble.kr(tr, #[220, 440]), 0) * 0.1

// TScramble - c-major sin tones across stereo field, scrambles on impulse
var tr = Impulse.kr(1, 0);
SinOsc.ar(TScramble.kr(tr, #[60, 62, 64, 65, 67, 69, 71, 72].midicps), 0).splay * 0.1

// TScramble - initially unscrambled
var tr = Dust.kr(1);
SinOsc.ar(TScramble.kr(tr, #[60, 62, 64, 65, 67, 69, 71, 72].midicps), 0).splay * 0.1

// TScramble ; reference
SinOsc.ar(#[60, 62, 64, 65, 67, 69, 71, 72].midicps, 0).splay * 0.1
