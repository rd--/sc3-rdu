// PV_DecayTable ; FFT pass through sanity check
var b0 = LocalBuf.new(2048);
IFFT.ar(FFT.new(b0, SoundIn.ar(0)))

// PV_DecayTable ; random decay multipliers
var b0 = LocalBuf.new(2048).clear;
var b1 = LocalBuf.newFrom({ 0.5.rrand(0.975) } ! 1024);
var b2 = LocalBuf(1024).clear;
IFFT.ar(PV_DecayTable(FFT.new(b0, SoundIn.ar(0)), b1, b2))

/* ---- ; notes

A PV_ unit generator that tracks the rise of magnitudes immediately,
but decays them according to a set of multipliers given in a table.
At each frame each partial decays by the amount indicated in the table,
if the decaying value is below the input value it is reset. */
