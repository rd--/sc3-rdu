-- | RDU UGen definitions.
module Sound.SC3.UGen.External.RDU where

import Sound.SC3.Identifier
import Sound.SC3.UGen.DB.Record
import Sound.SC3.UGen.Rate
import Sound.SC3.UGen.UGen

dustR_dsc :: U
dustR_dsc = U "DustR" [AR] AR [I "lo" 0.0001,I "hi" 1.0] 1

dustR :: ID a => a -> Rate -> UGen -> UGen -> UGen
dustR z rt lo hi = mkOscId z rt "DustR" [lo,hi] 1

rDelayMap_dsc :: U
rDelayMap_dsc =
    let i = [I "bufnum" 0,I "input" 0,I "dynamic" 0,I "mapArray" 0]
    in U "RDelayMap" [AR] AR i 1

-- | Network of delay line operations.
rDelayMap :: UGen -> UGen -> UGen -> UGen -> UGen
rDelayMap b i d s = mkFilterMCE "RDelayMap" [b,i,d] s 1

rDelaySet_dsc :: U
rDelaySet_dsc =
    let i = [I "input" 0,I "setArray" 0]
    in U "RDelaySet" [AR] AR i 1

rDelaySet :: UGen -> UGen -> UGen
rDelaySet i s = mkFilterMCE "RDelaySet" [i] s 1

rDelaySetB_dsc :: U
rDelaySetB_dsc =
    let i = [I "buffer" 0,I "input" 0,I "setArray" 0]
    in U "RDelaySetB" [AR] AR i 1

rDelaySetB :: UGen -> UGen -> UGen -> UGen
rDelaySetB b i s = mkFilterMCE "RDelaySetB" [b,i] s 1

rFreezer_dsc :: U
rFreezer_dsc =
    let i = [I "bufnum" 0
            ,I "left" 0
            ,I "right" 1
            ,I "gain" 0.1
            ,I "increment" 1
            ,I "incrementOffset" 0
            ,I "incrementRandom" 0.05
            ,I "rightRandom" 0.05
            ,I "syncPhaseTrigger" 0
            ,I "randomizePhaseTrigger" 0
            ,I "numberOfLoops" 6]
    in U "RFreezer" [AR] AR i 1

rFreezer :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rFreezer b l r g i io ir rr ps pt nl =
    mkOsc AR "RFreezer" [b,l,r,g,i,io,ir,rr,ps,pt,nl] 1

rShufflerB :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rShufflerB b rlL rlR riL riR dL dR eaL eaR esL esR ekL ekR slM slR ioL ioR i riQ ioQ =
    let p = [b,rlL,rlR,riL,riR,dL,dR,eaL,eaR,esL,esR,ekL,ekR,slM,slR,ioL,ioR,i,riQ,ioQ]
    in mkOsc AR "RShufflerB" p 2

rShufflerB_dsc :: U
rShufflerB_dsc =
 let i = [I "bufnum" 0
         ,I "readLocationMinima" 0
         ,I "readLocationMaxima" 1
         ,I "readIncrementMinima" 0.5
         ,I "readIncrementMaxima" 2
         ,I "durationMinima" 0.001
         ,I "durationMaxima" 0.015
         ,I "envelopeAmplitudeMinima" 0.05
         ,I "envelopeAmplitudeMaxima" 0.15
         ,I "envelopeShapeMinima" 0
         ,I "envelopeShapeMaxima" 1
         ,I "envelopeSkewMinima" 0
         ,I "envelopeSkewMaxima" 1
         ,I "stereoLocationMinima" 0
         ,I "stereoLocationMaxima" 1
         ,I "interOffsetTimeMinima" 0.001
         ,I "interOffsetTimeMaxima" 0.010
         ,I "ftableReadLocationIncrement" 0
         ,I "readIncrementQuanta" 0
         ,I "interOffsetTimeQuanta" 0]
 in U "RShufflerB" [AR] AR i 2

data RShufflerB a = RShufflerB {bufnum :: a
                               ,readLocationMinima :: a
                               ,readLocationMaxima :: a
                               ,readIncrementMinima :: a
                               ,readIncrementMaxima :: a
                               ,durationMinima :: a
                               ,durationMaxima :: a
                               ,envelopeAmplitudeMinima :: a
                               ,envelopeAmplitudeMaxima :: a
                               ,envelopeShapeMinima :: a
                               ,envelopeShapeMaxima :: a
                               ,envelopeSkewMinima :: a
                               ,envelopeSkewMaxima :: a
                               ,stereoLocationMinima :: a
                               ,stereoLocationMaxima :: a
                               ,interOffsetTimeMinima :: a
                               ,interOffsetTimeMaxima :: a
                               ,ftableReadLocationIncrement :: a
                               ,readIncrementQuanta :: a
                               ,interOffsetTimeQuanta :: a
                               }

rShufflerB_r :: RShufflerB UGen -> UGen
rShufflerB_r r =
    let (RShufflerB b rlL rlR riL riR dL dR eaL eaR esL esR ekL ekR slM slR ioL ioR i riQ ioQ) = r
    in rShufflerB b rlL rlR riL riR dL dR eaL eaR esL esR ekL ekR slM slR ioL ioR i riQ ioQ

rShufflerL_dsc :: U
rShufflerL_dsc =
    let i = [I "in" 0,I "fragmentSize" 0.005,I "maxDelay" 0.005]
    in U "RShufflerL" [AR] AR i 1

rShufflerL :: UGen -> UGen -> UGen -> UGen
rShufflerL i fs md = mkFilterR [AR] "RShufflerL" [i,fs,md] 1

-- Local Variables:
-- truncate-lines:t
-- End:
