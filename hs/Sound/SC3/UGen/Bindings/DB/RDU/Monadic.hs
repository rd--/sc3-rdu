module Sound.SC3.UGen.Bindings.DB.RDU.Monadic where

import Sound.SC3.Common.Rate
import Sound.SC3.Common.UId
import Sound.SC3.UGen.Type

import Sound.SC3.UGen.Bindings.DB.RDU

-- * Monadic

dustRM :: UId m => Rate -> UGen -> UGen -> m UGen
dustRM = liftUId3 dustR

expRandNM :: UId m => Int -> UGen -> UGen -> m UGen
expRandNM nc = liftUId2 (expRandN nc)

iRandNM :: UId m => Int -> UGen -> UGen -> m UGen
iRandNM nc = liftUId2 (iRandN nc)

linRandNM :: UId m => Int -> UGen -> UGen -> UGen -> m UGen
linRandNM nc = liftUId3 (linRandN nc)

randNM :: UId m => Int -> UGen -> UGen -> m UGen
randNM nc = liftUId2 (randN nc)

rTScrambleM :: UId m => UGen -> UGen -> m UGen
rTScrambleM = liftUId2 rTScramble
