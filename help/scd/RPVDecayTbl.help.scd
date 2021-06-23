// RPVDecayTbl - FFT pass through sanity check
{var b0 = LocalBuf(2048)
;IFFT.ar(FFT(b0,SoundIn.ar(0)))}

// RPVDecayTbl - random decay multipliers
{var b0 = LocalBuf(2048).clear
;var b1 = LocalBuf.newFrom(Array.fill(1024,{rrand(0.5,0.975)}))
;var b2 = LocalBuf(1024).clear
;IFFT.ar(RPVDecayTbl(FFT(b0,SoundIn.ar(0)),b1,b2))}
