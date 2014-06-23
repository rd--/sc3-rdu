-- | RDU UGen definitions.
module Sound.SC3.UGen.External.RDU.Monad where

import Sound.SC3.UGen.Rate
import Sound.SC3.UGen.Type
import Sound.SC3.UGen.UId

import qualified Sound.SC3.UGen.External.RDU.ID as I

dustR :: UId m => Rate -> UGen -> UGen -> m UGen
dustR = liftUId3 I.dustR

expRandN :: UId m => Int -> UGen -> UGen -> m UGen
expRandN nc = liftUId2 (I.expRandN nc)

linRandN :: UId m => Int -> UGen -> UGen -> UGen -> m UGen
linRandN nc = liftUId3 (I.linRandN nc)

randN :: UId m => Int -> UGen -> UGen -> m UGen
randN nc = liftUId2 (I.randN nc)

tScramble :: UId m => Rate -> UGen -> UGen -> m UGen
tScramble = liftUId3 I.tScramble
