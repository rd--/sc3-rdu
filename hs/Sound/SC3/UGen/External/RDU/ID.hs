-- | RDU UGen definitions.
module Sound.SC3.UGen.External.RDU.ID where

import Sound.SC3.UGen.Identifier
import Sound.SC3.UGen.Rate
import Sound.SC3.UGen.Type
import Sound.SC3.UGen.UGen

dustR :: ID z => z -> Rate -> UGen -> UGen -> UGen
dustR z rt lo hi = mkOscId z rt "DustR" [lo,hi] 1

expRandN :: ID z => Int -> z -> UGen -> UGen -> UGen
expRandN nc z l r = mkOscId z IR "ExpRandN" [l,r] nc

linRandN :: ID z => Int -> z -> UGen -> UGen -> UGen
linRandN nc z l r = mkOscId z IR "LinRandN" [l,r] nc

randN :: ID z => Int -> z -> UGen -> UGen -> UGen
randN nc z l r = mkOscId z IR "RandN" [l,r] nc

tScramble :: ID z => z -> Rate -> UGen -> UGen -> UGen
tScramble z rt tr i = mkOscMCEId z rt "TScramble" [tr] i (mceDegree i)
