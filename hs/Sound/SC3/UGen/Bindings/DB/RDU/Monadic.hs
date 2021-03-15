module Sound.SC3.UGen.Bindings.DB.RDU.Monadic where

import Sound.SC3.Common.Rate
import Sound.SC3.Common.UId
import Sound.SC3.UGen.Type

import Sound.SC3.UGen.Bindings.DB.RDU

-- * Monadic

rDustRM :: UId m => Rate -> UGen -> UGen -> m UGen
rDustRM = liftUId3 rDustR

rExpRandNM :: UId m => Int -> UGen -> UGen -> m UGen
rExpRandNM nc = liftUId2 (rExpRandN nc)

riRandNM :: UId m => Int -> UGen -> UGen -> m UGen
riRandNM nc = liftUId2 (riRandN nc)

rLinRandNM :: UId m => Int -> UGen -> UGen -> UGen -> m UGen
rLinRandNM nc = liftUId3 (rLinRandN nc)

rRandNM :: UId m => Int -> UGen -> UGen -> m UGen
rRandNM nc = liftUId2 (rRandN nc)

rtScrambleM :: UId m => UGen -> UGen -> m UGen
rtScrambleM = liftUId2 rtScramble
