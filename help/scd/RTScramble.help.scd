// RTScramble - octaves, swaps channels on impulse, scramble may be identity
var tr = Impulse.kr(1, 0);
SinOsc.ar(RTScramble.kr(tr, #[220, 440]), 0) * 0.1

// RTScramble - c-major sin tones across stereo field, scrambles on impulse
var tr = Impulse.kr(1, 0);
SinOsc.ar(RTScramble.kr(tr, #[60, 62, 64, 65, 67, 69, 71, 72].midicps), 0).splay * 0.1

// RTScramble - initially unscrambled
var tr = Dust.kr(1);
SinOsc.ar(RTScramble.kr(tr, #[60, 62, 64, 65, 67, 69, 71, 72].midicps), 0).splay * 0.1

// RTScramble ; reference
SinOsc.ar(#[60, 62, 64, 65, 67, 69, 71, 72].midicps, 0).splay * 0.1
