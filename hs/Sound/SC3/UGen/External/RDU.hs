-- | RDU UGen definitions.
module Sound.SC3.UGen.External.RDU where

import Sound.SC3.UGen.DB.Record
import Sound.SC3.UGen.Rate
import Sound.SC3.UGen.Type
import Sound.SC3.UGen.UGen

std_I :: Int -> String -> Double -> I
std_I ix nm df = I (ix,ix) nm df Nothing

osc_U :: String -> [Rate] -> Rate -> [I] -> Int -> String -> U
osc_U nm rr r i nc dsc = U nm rr r Nothing i Nothing (Left nc) dsc

dustR_dsc :: U
dustR_dsc =
    let i = [std_I 0 "lo" 0.0001
            ,std_I 1 "hi" 1.0]
    in osc_U "DustR" [AR] AR i 1 "Range variant of Dust"

expRandN_dsc :: U
expRandN_dsc =
    let i = [std_I 0 "lo" 0.0001
            ,std_I 1 "hi" 1.0]
        dsc = "Multi-channel variant of Rand"
    in U "ExpRandN" [IR] IR Nothing i Nothing (Right 0) dsc

-- | Copies spectral frame (ie. PV_Copy with two outputs).
pv_Split :: UGen -> UGen -> UGen
pv_Split ba bb = mkOsc KR "PV_Split" [ba,bb] 2

-- | Variant that unpacks the output /mce/ node.
pv_split :: UGen -> UGen -> (UGen,UGen)
pv_split a b =
    case mceChannels (pv_Split a b) of
      [p,q] -> (p,q)
      _ -> error "pv_split"

randN_dsc :: U
randN_dsc =
    let i = [std_I 0 "lo" 0.0001
            ,std_I 1 "hi" 1.0]
        dsc = "Multi-channel variant of Rand"
    in U "RandN" [IR] IR Nothing i Nothing (Right 0) dsc

rDelayMap_dsc :: U
rDelayMap_dsc =
    let i = [std_I 0 "bufnum" 0
            ,std_I 1 "input" 0
            ,std_I 2 "dynamic" 0
            ,std_I 3 "mapArray" 0]
    in osc_U "RDelayMap" [AR] AR i 1 "Network of delay line maps"

-- | Network of delay line operations.
rDelayMap :: UGen -> UGen -> UGen -> UGen -> UGen
rDelayMap b i d s = mkFilterMCE "RDelayMap" [b,i,d] s 1

rDelaySet_dsc :: U
rDelaySet_dsc =
    let i = [std_I 0 "input" 0
            ,std_I 1 "setArray" 0]
    in osc_U "RDelaySet" [AR] AR i 1 "Delay set (RTAlloc)"

rDelaySet :: UGen -> UGen -> UGen
rDelaySet i s = mkFilterMCE "RDelaySet" [i] s 1

rDelaySetB_dsc :: U
rDelaySetB_dsc =
    let i = [std_I 0 "buffer" 0
            ,std_I 1 "input" 0
            ,std_I 2 "setArray" 0]
    in osc_U "RDelaySetB" [AR] AR i 1 "Delay set (Buffer)"

rDelaySetB :: UGen -> UGen -> UGen -> UGen
rDelaySetB b i s = mkFilterMCE "RDelaySetB" [b,i] s 1

rdl_dsc :: U
rdl_dsc =
    let i = [std_I 0 "inputs" 0]
    in osc_U "RDL" [AR] AR i 1 "Dynamic library host"

rdl :: Int -> UGen -> UGen
rdl nc i = mkOscMCE AR "RDL" [] i nc

rFreezer_dsc :: U
rFreezer_dsc =
    let i = [std_I 0 "bufnum" 0
            ,std_I 1 "left" 0
            ,std_I 2 "right" 1
            ,std_I 3 "gain" 0.1
            ,std_I 4 "increment" 1
            ,std_I 5 "incrementOffset" 0
            ,std_I 6 "incrementRandom" 0.05
            ,std_I 7 "rightRandom" 0.05
            ,std_I 8 "syncPhaseTrigger" 0
            ,std_I 9 "randomizePhaseTrigger" 0
            ,std_I 10 "numberOfLoops" 6]
    in osc_U "RFreezer" [AR] AR i 1 "Concurrent loops at signal buffer"

rFreezer :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rFreezer b l r g i io ir rr ps pt nl =
    mkOsc AR "RFreezer" [b,l,r,g,i,io,ir,rr,ps,pt,nl] 1

rShufflerB :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rShufflerB b rlL rlR riL riR dL dR eaL eaR esL esR ekL ekR slM slR ioL ioR i riQ ioQ =
    let p = [b,rlL,rlR,riL,riR,dL,dR,eaL,eaR,esL,esR,ekL,ekR,slM,slR,ioL,ioR,i,riQ,ioQ]
    in mkOsc AR "RShufflerB" p 2

rShufflerB_dsc :: U
rShufflerB_dsc =
 let i = [std_I 0 "bufnum" 0
         ,std_I 1 "readLocationMinima" 0
         ,std_I 2 "readLocationMaxima" 1
         ,std_I 3 "readIncrementMinima" 0.5
         ,std_I 4 "readIncrementMaxima" 2
         ,std_I 5 "durationMinima" 0.001
         ,std_I 6 "durationMaxima" 0.015
         ,std_I 7 "envelopeAmplitudeMinima" 0.05
         ,std_I 8 "envelopeAmplitudeMaxima" 0.15
         ,std_I 9 "envelopeShapeMinima" 0
         ,std_I 10 "envelopeShapeMaxima" 1
         ,std_I 11 "envelopeSkewMinima" 0
         ,std_I 12 "envelopeSkewMaxima" 1
         ,std_I 13 "stereoLocationMinima" 0
         ,std_I 14 "stereoLocationMaxima" 1
         ,std_I 15 "interOffsetTimeMinima" 0.001
         ,std_I 16 "interOffsetTimeMaxima" 0.010
         ,std_I 17 "ftableReadLocationIncrement" 0
         ,std_I 18 "readIncrementQuanta" 0
         ,std_I 19 "interOffsetTimeQuanta" 0]
 in osc_U "RShufflerB" [AR] AR i 2 "Signal shuffler (Buffer)"

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
    let i = [std_I 0 "in" 0
            ,std_I 1 "fragmentSize" 0.005
            ,std_I 2 "maxDelay" 0.005]
    in osc_U "RShufflerL" [AR] AR i 1 "Signal shuffler (Linear)"

rShufflerL :: UGen -> UGen -> UGen -> UGen
rShufflerL i fs md = mkFilterR [AR] "RShufflerL" [i,fs,md] 1

rTraceRd_dsc :: U
rTraceRd_dsc =
    let i = [std_I 0 "bufnum" 0
            ,std_I 1 "degree" 4
            ,std_I 2 "index" 0
            ,std_I 3 "access" 1]
    in osc_U "RTraceRd" [AR] AR i 1 "Read trace buffer"

rTraceRd :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen
rTraceRd rt b d ix ac = mkOsc rt "RTraceRd" [b,d,ix,ac] 1

rPlayTrace_dsc :: U
rPlayTrace_dsc =
    let i = [std_I 0 "bufnum" 0
            ,std_I 1 "degree" 4
            ,std_I 2 "rate" 0
            ,std_I 3 "access" 1]
    in osc_U "RPlayTrace" [AR] AR i 1 "Play trace buffer"

rPlayTrace :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen
rPlayTrace rt b d ix ac = mkOsc rt "RPlayTrace" [b,d,ix,ac] 1

-- | The number of outputs is the length of the inputs array.
tScramble_dsc :: U
tScramble_dsc =
    let i = [std_I 0 "trigger" 0
            ,std_I 1 "inputs" 0]
        s = "Scramble inputs on trigger."
    in U "TScramble" [KR] KR Nothing i (Just 1) (Right 1) s

-- Local Variables:
-- truncate-lines:t
-- End:
