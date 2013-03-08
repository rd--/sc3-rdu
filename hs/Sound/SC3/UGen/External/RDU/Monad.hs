-- | RDU UGen definitions.
module Sound.SC3.UGen.External.RDU.Monad where

import Sound.SC3.UGen.Rate
import Sound.SC3.UGen.Type
import Sound.SC3.UGen.UGen.Lift
import Sound.SC3.UGen.UId

import qualified Sound.SC3.UGen.External.RDU.ID as I

dustR :: UId m => Rate -> UGen -> UGen -> m UGen
dustR = liftU3 I.dustR

expRandN :: UId m => Int -> UGen -> UGen -> m UGen
expRandN nc = liftU2 (I.expRandN nc)

randN :: UId m => Int -> UGen -> UGen -> m UGen
randN nc = liftU2 (I.randN nc)

tScramble :: UId m => Rate -> UGen -> UGen -> m UGen
tScramble = liftU3 I.tScramble
