-- | RDU UGen definitions.
module Sound.SC3.UGen.External.RDU where

import Sound.SC3.UGen {- hsc3 -}

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

u_std_mce :: U -> U
u_std_mce u = u {ugen_std_mce = True}

u_ir :: U -> U
u_ir u = u {ugen_fixed_rate = Just IR}

u_ar :: U -> U
u_ar u = u {ugen_fixed_rate = Just AR}

u_flt :: Int -> U -> U
u_flt k u = u {ugen_filter = Just [k]}

-- * DSC

dustR_dsc :: U
dustR_dsc =
    let i = [std_I 0 "lo" 0.0001
            ,std_I 1 "hi" 1.0]
    in osc_U "DustR" [AR] AR i 1 "Range variant of Dust" True

expRandN_dsc :: U
expRandN_dsc =
    let i = [std_I 0 "lo" 0.0001
            ,std_I 1 "hi" 1.0]
        dsc = "Multi-channel variant of Rand"
    in u_ir (u_nc_input (osc_U "ExpRandN" [IR] IR i (-1) dsc True))

iRandN_dsc :: U
iRandN_dsc =
    let i = [std_I 0 "lo" 0.0001
            ,std_I 1 "hi" 1.0]
        dsc = "Multi-channel variant of IRand"
    in u_ir (u_nc_input (osc_U "IRandN" [IR] IR i (-1) dsc True))

linRandN_dsc :: U
linRandN_dsc =
    let i = [std_I 0 "lo" 0.0001
            ,std_I 1 "hi" 1.0]
        dsc = "Multi-channel variant of LinRand"
    in u_ir (u_nc_input (osc_U "LinRandN" [IR] IR i (-1) dsc True))

pv_Split_dsc :: U
pv_Split_dsc =
  let i = [std_I 0 "bufferA" 0
          ,std_I 1 "bufferB" 0]
      dsc = "Copies spectral frame (ie. PV_Copy with two outputs)."
  in osc_U "PV_Split" [KR] KR i 2 dsc False

randN_dsc :: U
randN_dsc =
    let i = [std_I 0 "lo" 0.0001
            ,std_I 1 "hi" 1.0]
        dsc = "Multi-channel variant of Rand"
    in u_ir (u_nc_input (osc_U "RandN" [IR] IR i (-1) dsc True))

rBezier_dsc :: U
rBezier_dsc =
  let i = [std_I 0 "freq" 440
          ,std_I 1 "phase" 0
          ,std_I 2 "param" 0]
      dsc = "Bezier curve oscillator."
  in u_std_mce (osc_U "RBezier" [KR,AR] AR i 1 dsc False)

rDelayMap_dsc :: U
rDelayMap_dsc =
    let i = [std_I 0 "bufnum" 0
            ,std_I 1 "input" 0
            ,std_I 2 "dynamic" 0
            ,std_I 3 "mapArray" 0]
    in u_flt 1 (u_std_mce (osc_U "RDelayMap" [AR] AR i 1 "Network of delay line maps" False))

rDelaySet_dsc :: U
rDelaySet_dsc =
    let i = [std_I 0 "input" 0
            ,std_I 1 "setArray" 0]
    in u_flt 0 (u_std_mce (osc_U "RDelaySet" [AR] AR i 1 "Delay set (RTAlloc)" False))

rDelaySetB_dsc :: U
rDelaySetB_dsc =
    let i = [std_I 0 "buffer" 0
            ,std_I 1 "input" 0
            ,std_I 2 "setArray" 0]
    in u_flt 1 (u_std_mce (osc_U "RDelaySetB" [AR] AR i 1 "Delay set (Buffer)" False))

rdl_dsc :: U
rdl_dsc =
    let i = [std_I 0 "inputs" 0]
    in u_ar (u_std_mce (u_nc_input (osc_U "RDL" [AR] AR i 1 "Dynamic library host" False)))

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
    in u_ar (osc_U "RFreezer" [AR] AR i 1 "Concurrent loops at signal buffer" False)

rpvDecayTbl_dsc :: U
rpvDecayTbl_dsc =
    let i = [std_I 0 "fft_buf" 0
            ,std_I 1 "decay_rate_buf" 0
            ,std_I 2 "history_buf" 0]
    in osc_U "RPVDecayTbl" [KR] KR i 1 "Decay bin magnitudes according to multipliers in table." False

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

rShufflerL_dsc :: U
rShufflerL_dsc =
    let i = [std_I 0 "in" 0
            ,std_I 1 "fragmentSize" 0.005
            ,std_I 2 "maxDelay" 0.005]
    in u_flt 0 (osc_U "RShufflerL" [AR] AR i 1 "Signal shuffler (Linear)" False)

rTraceRd_dsc :: U
rTraceRd_dsc =
    let i = [std_I 0 "bufnum" 0
            ,std_I 1 "degree" 4
            ,std_I 2 "index" 0
            ,std_I 3 "access" 1]
    in osc_U "RTraceRd" [KR,AR] AR i 1 "Read trace buffer" False

rPlayTrace_dsc :: U
rPlayTrace_dsc =
    let i = [std_I 0 "bufnum" 0
            ,std_I 1 "degree" 4
            ,std_I 2 "rate" 0
            ,std_I 3 "access" 1]
    in osc_U "RPlayTrace" [KR,AR] AR i 1 "Play trace buffer" False

tScramble_dsc :: U
tScramble_dsc =
    default_u {ugen_name = "TScramble"
              ,ugen_operating_rates = [IR,KR]
              ,ugen_inputs = [std_I 0 "trigger" 0,std_I 1 "inputs" 0]
              ,ugen_summary = "Scramble inputs on trigger."
              ,ugen_std_mce = True
              ,ugen_nc_mce = Just 0
              ,ugen_filter = Just [0]
              ,ugen_nondet = True
              }

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

-- * DB

rdu_db :: [U]
rdu_db =
    [dustR_dsc
    ,expRandN_dsc
    ,iRandN_dsc
    ,linRandN_dsc
    ,pv_Split_dsc
    ,randN_dsc
    ,rBezier_dsc
    ,rDelayMap_dsc
    ,rDelaySet_dsc
    ,rDelaySetB_dsc
    ,rdl_dsc
    ,rFreezer_dsc
    ,rPlayTrace_dsc
    ,rpvDecayTbl_dsc
    ,tRandN_dsc
    ,tScramble_dsc
    ,rShufflerB_dsc
    ,rShufflerL_dsc
    ,rTraceRd_dsc
    ]

gen_bindings :: IO ()
gen_bindings =
    let f = putStrLn . unlines . u_gen_binding
    in mapM_ f rdu_db

-- Local Variables:
-- truncate-lines:t
-- End:
