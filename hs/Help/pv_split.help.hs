import Sound.SC3.ID
import Sound.SC3.UGen.External.RDU

-- > audition (out 0 (spl1 (1024 * 2) (-) (soundIn 4)))
-- > audition (out 0 (spl1 (1024 * 16) (+) (soundIn 4)))
spl1 sz op z =
    let c0 = fft' (localBuf 'β' sz 1) z
        (c1,c2) = pv_split c0 (localBuf 'γ' sz 1)
    in ifft' c1 `op` ifft' c2

-- > audition (out 0 (spl2 (1024 * 16)))
spl2 sz =
    let z = lfClipNoise 'α' AR 100 * 0.1
    in spl1 sz (-) z
