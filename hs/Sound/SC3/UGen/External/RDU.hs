-- | RDU UGen definitions.
module Sound.SC3.UGen.External.RDU where

import Sound.SC3.UGen {- hsc3 -}
import Sound.SC3.UGen.Bindings.DB {- hsc3 -}
import Sound.SC3.UGen.Bindings.HW.Construct {- hsc3 -}

import Sound.SC3.UGen.DB.Bindings {- hsc3-db -}
import Sound.SC3.UGen.DB.Record {- hsc3-db -}

std_I :: Int -> String -> Double -> I
std_I _ nm df = I nm df

-- | Input meta-data, @(min,max,warp,step,units)@.
type I_Meta = (Double,Double,String,Double,String)

-- | In cases where inputs have clear meta-data this should be stored
-- at hsc3-db, but it isn't.
std_I' :: Int -> String -> Double -> I_Meta -> I
std_I' ix nm df _ = std_I ix nm df

-- | Name, allowed rates, default rate, inputs, number of channels, description, non-det flag.
osc_U :: String -> [Rate] -> Rate -> [I] -> Int -> String -> Bool -> U
osc_U nm rr r i nc dsc nd = (read_meta (nm,rr,r,i,nc,dsc)) {ugen_nondet = nd}

u_nc_input :: U -> U
u_nc_input u = u {ugen_outputs = Nothing,ugen_nc_input = True}

-- * Bindings

dustR_dsc :: U
dustR_dsc =
    let i = [std_I 0 "lo" 0.0001
            ,std_I 1 "hi" 1.0]
    in osc_U "DustR" [AR] AR i 1 "Range variant of Dust" True

dustR :: ID z => z -> Rate -> UGen -> UGen -> UGen
dustR z rt lo hi = mkOscId (toUId z) rt "DustR" [lo,hi] 1

expRandN_dsc :: U
expRandN_dsc =
    let i = [std_I 0 "lo" 0.0001
            ,std_I 1 "hi" 1.0]
        dsc = "Multi-channel variant of Rand"
    in u_nc_input (osc_U "ExpRandN" [IR] IR i (-1) dsc True)

expRandN :: ID z => Int -> z -> UGen -> UGen -> UGen
expRandN nc z l r = mkOscId (toUId z) IR "ExpRandN" [l,r] nc

-- | Copies spectral frame (ie. PV_Copy with two outputs).
pv_Split :: UGen -> UGen -> UGen
pv_Split ba bb = mkOsc KR "PV_Split" [ba,bb] 2

-- | Variant that unpacks the output /mce/ node.
pv_Split' :: UGen -> UGen -> (UGen,UGen)
pv_Split' a b =
    case mceChannels (pv_Split a b) of
      [p,q] -> (p,q)
      _ -> error "pv_split"

-- | A 'pv_Split' variant, like 'ffta', that allocates a 'localBuf' by
-- tracing the input graph to locate the parent @FFT@ or @PV_Split@
-- node.
pv_Splita :: ID i => i -> UGen -> UGen
pv_Splita z u =
    case pv_track_nframes u of
      Left err -> error err
      Right nf -> let b = localBuf z nf 1 in pv_Split u b

-- | Variant that unpacks the output /mce/ node.
pv_splita :: ID i => i -> UGen -> (UGen,UGen)
pv_splita z u =
    case mceChannels (pv_Splita z u) of
      [p,q] -> (p,q)
      _ -> error "pv_splita"

randN_dsc :: U
randN_dsc =
    let i = [std_I 0 "lo" 0.0001
            ,std_I 1 "hi" 1.0]
        dsc = "Multi-channel variant of Rand"
    in u_nc_input (osc_U "RandN" [IR] IR i (-1) dsc True)

rBezier :: Rate -> UGen -> UGen -> UGen -> UGen
rBezier rate freq phase param = mkUGen Nothing [AR] (Left rate) "RBezier" [freq,phase] (Just param) 1 (Special 0) NoId

rDelayMap_dsc :: U
rDelayMap_dsc =
    let i = [std_I 0 "bufnum" 0
            ,std_I 1 "input" 0
            ,std_I 2 "dynamic" 0
            ,std_I 3 "mapArray" 0]
    in osc_U "RDelayMap" [AR] AR i 1 "Network of delay line maps" False

-- | Network of delay line operations.
rDelayMap :: UGen -> UGen -> UGen -> UGen -> UGen
rDelayMap b i d s = mkFilterMCE "RDelayMap" [b,i,d] s 1

rDelaySet_dsc :: U
rDelaySet_dsc =
    let i = [std_I 0 "input" 0
            ,std_I 1 "setArray" 0]
    in osc_U "RDelaySet" [AR] AR i 1 "Delay set (RTAlloc)" False

rDelaySet :: UGen -> UGen -> UGen
rDelaySet i s = mkFilterMCE "RDelaySet" [i] s 1

rDelaySetB_dsc :: U
rDelaySetB_dsc =
    let i = [std_I 0 "buffer" 0
            ,std_I 1 "input" 0
            ,std_I 2 "setArray" 0]
    in osc_U "RDelaySetB" [AR] AR i 1 "Delay set (Buffer)" False

rDelaySetB :: UGen -> UGen -> UGen -> UGen
rDelaySetB b i s = mkFilterMCE "RDelaySetB" [b,i] s 1

rdl_dsc :: U
rdl_dsc =
    let i = [std_I 0 "inputs" 0]
    in osc_U "RDL" [AR] AR i 1 "Dynamic library host" False

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
    in osc_U "RFreezer" [AR] AR i 1 "Concurrent loops at signal buffer" False

rFreezer :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rFreezer b l r g i io ir rr ps pt nl =
    mkOsc AR "RFreezer" [b,l,r,g,i,io,ir,rr,ps,pt,nl] 1

rpvDecayTbl_dsc :: U
rpvDecayTbl_dsc =
    let i = [std_I 0 "fft_buf" 0
            ,std_I 1 "decay_rate_buf" 0
            ,std_I 2 "history_buf" 0]
    in osc_U "RPVDecayTbl" [KR] KR i 1 "Decay bin magnitudes according to multipliers in table." False

rpvDecayTbl :: UGen -> UGen -> UGen -> UGen
rpvDecayTbl b_fft b_dcy b_hst = mkUGen Nothing [KR] (Left KR) "RPVDecayTbl" [b_fft,b_dcy,b_hst] Nothing 1 (Special 0) NoId

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
 in osc_U "RShufflerB" [AR] AR i 2 "Signal shuffler (Buffer)" False

rShufflerB :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rShufflerB b rlL rlR riL riR dL dR eaL eaR esL esR ekL ekR slM slR ioL ioR i riQ ioQ =
    let p = [b,rlL,rlR,riL,riR,dL,dR,eaL,eaR,esL,esR,ekL,ekR,slM,slR,ioL,ioR,i,riQ,ioQ]
    in mkOsc AR "RShufflerB" p 2

{-

-> Sound.SC3.UGen.Record.Plain.RShufflerB

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

-}

rShufflerL_dsc :: U
rShufflerL_dsc =
    let i = [std_I 0 "in" 0
            ,std_I 1 "fragmentSize" 0.005
            ,std_I 2 "maxDelay" 0.005]
    in osc_U "RShufflerL" [AR] AR i 1 "Signal shuffler (Linear)" False

rShufflerL :: UGen -> UGen -> UGen -> UGen
rShufflerL i fs md = mkFilterR [AR] "RShufflerL" [i,fs,md] 1

rTraceRd_dsc :: U
rTraceRd_dsc =
    let i = [std_I 0 "bufnum" 0
            ,std_I 1 "degree" 4
            ,std_I 2 "index" 0
            ,std_I 3 "access" 1]
    in osc_U "RTraceRd" [AR] AR i 1 "Read trace buffer" False

rTraceRd :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen
rTraceRd rt b d ix ac = mkOsc rt "RTraceRd" [b,d,ix,ac] 1

rPlayTrace_dsc :: U
rPlayTrace_dsc =
    let i = [std_I 0 "bufnum" 0
            ,std_I 1 "degree" 4
            ,std_I 2 "rate" 0
            ,std_I 3 "access" 1]
    in osc_U "RPlayTrace" [AR] AR i 1 "Play trace buffer" False

rPlayTrace :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen
rPlayTrace rt b d ix ac = mkOsc rt "RPlayTrace" [b,d,ix,ac] 1

tScramble_dsc :: U
tScramble_dsc =
    default_u {ugen_name = "TScramble"
              ,ugen_operating_rates = [KR]
              ,ugen_inputs = [std_I 0 "trigger" 0,std_I 1 "inputs" 0]
              ,ugen_summary = "Scramble inputs on trigger."
              ,ugen_std_mce = True
              ,ugen_nc_mce = Just 0
              ,ugen_filter = Just [0]
              ,ugen_nondet = True
              }

-- | Scramble inputs on trigger.
--
--  TScramble [KR] trigger=0.0 *inputs=0.0;    MCE, FILTER: TRUE, NONDET
tScramble :: ID a => a -> UGen -> UGen -> UGen
tScramble z trigger inputs = mkUGen Nothing [KR] (Right [0]) "TScramble" [trigger] (Just inputs) (length (mceChannels inputs) + 0) (Special 0) (toUId z)

iRandN :: ID z => Int -> z -> UGen -> UGen -> UGen
iRandN nc z l r = mkOscId (toUId z) IR "IRandN" [l,r] nc

linRandN :: ID z => Int -> z -> UGen -> UGen -> UGen -> UGen
linRandN nc z l r bias = mkOscId (toUId z) IR "LinRandN" [l,r,bias] nc

randN :: ID z => Int -> z -> UGen -> UGen -> UGen
randN nc z l r = mkOscId (toUId z) IR "RandN" [l,r] nc

tRandN_dsc :: U
tRandN_dsc =
    default_u {ugen_name = "TRandN"
              ,ugen_operating_rates = [KR]
              ,ugen_inputs = [std_I 0 "lo" 0,std_I 1 "hi" 1,std_I 2 "trigger" 0]
              ,ugen_summary = "Generate new random values on trigger."
              ,ugen_nc_input = True
              ,ugen_filter = Just [2]
              ,ugen_nondet = True
              }
-- | Generate new random values on trigger.
--
--  TRandN [KR] lo=0.0 hi=1.0 trigger=0.0;    NC INPUT: True, FILTER: TRUE, NONDET
tRandN :: ID a => Int -> a -> UGen -> UGen -> UGen -> UGen
tRandN numChannels z lo hi trigger = mkUGen Nothing [KR] (Right [2]) "TRandN" [lo,hi,trigger] Nothing numChannels (Special 0) (toUId z)

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

tScrambleM :: UId m => UGen -> UGen -> m UGen
tScrambleM = liftUId2 tScramble

rdu_db :: [U]
rdu_db =
    [dustR_dsc
    ,expRandN_dsc,randN_dsc,tRandN_dsc
    ,rDelayMap_dsc
    ,rDelaySet_dsc,rDelaySetB_dsc
    ,rdl_dsc
    ,rFreezer_dsc
    ,rShufflerB_dsc,rShufflerL_dsc
    ,rTraceRd_dsc,rPlayTrace_dsc
    ,tScramble_dsc]

gen_bindings :: IO ()
gen_bindings =
    let f = putStrLn . unlines . u_gen_binding
    in mapM_ f rdu_db

-- Local Variables:
-- truncate-lines:t
-- End:
