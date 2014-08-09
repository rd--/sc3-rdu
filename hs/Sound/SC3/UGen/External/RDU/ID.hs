-- | RDU UGen definitions.
module Sound.SC3.UGen.External.RDU.ID where

import Sound.SC3.UGen.Identifier
import Sound.SC3.UGen.Rate
import Sound.SC3.UGen.Type
import Sound.SC3.UGen.UGen
import Sound.SC3.UGen.UGen.Construct

dustR :: ID z => z -> Rate -> UGen -> UGen -> UGen
dustR z rt lo hi = mkOscId (toUId z) rt "DustR" [lo,hi] 1

expRandN :: ID z => Int -> z -> UGen -> UGen -> UGen
expRandN nc z l r = mkOscId (toUId z) IR "ExpRandN" [l,r] nc

iRandN :: ID z => Int -> z -> UGen -> UGen -> UGen
iRandN nc z l r = mkOscId (toUId z) IR "IRandN" [l,r] nc

linRandN :: ID z => Int -> z -> UGen -> UGen -> UGen -> UGen
linRandN nc z l r bias = mkOscId (toUId z) IR "LinRandN" [l,r,bias] nc

randN :: ID z => Int -> z -> UGen -> UGen -> UGen
randN nc z l r = mkOscId (toUId z) IR "RandN" [l,r] nc

tScramble :: ID z => z -> Rate -> UGen -> UGen -> UGen
tScramble z rt tr i = mkOscMCEId (toUId z) rt "TScramble" [tr] i (mceDegree i)
