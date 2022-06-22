-- | Rdu Ugen definitions.
module Sound.Sc3.Ugen.External.Rdu where

import Text.Printf {- base -}

import Sound.Sc3 {- hsc3 -}

import qualified Sound.Sc3.Ugen.Db.Bindings.Haskell as Haskell {- hsc3-db -}
import qualified Sound.Sc3.Ugen.Db.Bindings.Scheme as Scheme {- hsc3-db -}
import Sound.Sc3.Ugen.Db.Record {- hsc3-db -}

-- | In cases where inputs have clear meta-data this should be stored at hsc3-db, but it isn't.
std_I_meta :: String -> Double -> Control_Meta_T5 Double -> I
std_I_meta nm df _ = I nm df

c_meta_cs_pp :: Control_Meta_T5 Double -> Double -> String
c_meta_cs_pp (lhs,rhs,warp,step,_units) def =
  let warp' = case warp of
                "linear" -> "LinearWarp"
                "exponential" -> "ExponentialWarp"
                _ -> error "c_meta_cs_pp"
  in printf "ControlSpec.new(%0.4f, %0.4f, %s, %0.4f, %0.4f)" lhs rhs warp' step def

-- | Name, allowed rates, default rate, inputs, number of channels, description, non-det flag.
osc_U :: String -> [Rate] -> Rate -> [I] -> Int -> String -> Bool -> U
osc_U nm rr r i nc dsc nd = (read_meta (nm,rr,r,i,nc,dsc,not nd)) {ugen_nondet = nd}

u_nc_input :: U -> U
u_nc_input u = u {ugen_outputs = Nothing,ugen_nc_input = True}

u_std_mce :: Int -> U -> U
u_std_mce n u = u {ugen_std_mce = n}

u_ir :: U -> U
u_ir u = u {ugen_fixed_rate = Just ir}

u_ar :: U -> U
u_ar u = u {ugen_fixed_rate = Just ar}

u_flt :: Int -> U -> U
u_flt k u = u {ugen_filter = Just [k]}

-- * DSC

dustRange_dsc :: U
dustRange_dsc =
    let i = [I "lo" 0.0001
            ,I "hi" 1.0]
    in osc_U "DustRange" [ar] ar i 1 "Range variant of Dust" True

expRandN_dsc :: U
expRandN_dsc =
    let i = [I "lo" 0.0001
            ,I "hi" 1.0]
        dsc = "Multi-channel variant of ExpRand"
    in u_ir (u_nc_input (osc_U "ExpRandN" [ir] ir i (-1) dsc True))

iRandN_dsc :: U
iRandN_dsc =
    let i = [I "lo" 0.0001
            ,I "hi" 1.0]
        dsc = "Multi-channel variant of irand"
    in u_ir (u_nc_input (osc_U "IRandN" [ir] ir i (-1) dsc True))

linRandN_dsc :: U
linRandN_dsc =
    let i = [I "lo" 0.0001
            ,I "hi" 1.0
            ,I "minmax" 0.0]
        dsc = "Multi-channel variant of LinRand"
    in u_ir (u_nc_input (osc_U "LinRandN" [ir] ir i (-1) dsc True))

pv_Split_dsc :: U
pv_Split_dsc =
  let i = [I "bufferA" 0
          ,I "bufferB" 0]
      dsc = "Copies spectral frame (ie. PV_Copy with two outputs)."
  in osc_U "PV_Split" [kr] kr i 2 dsc False

randN_dsc :: U
randN_dsc =
    let i = [I "lo" 0.0001
            ,I "hi" 1.0]
        dsc = "Multi-channel variant of Rand"
    in u_ir (u_nc_input (osc_U "RandN" [ir] ir i (-1) dsc True))

bezier_dsc :: U
bezier_dsc =
  let i = [I "haltAfter" 100
          ,I "dx" 0.0001
          ,I "freq" 440
          ,I "phase" 0
          ,I "param" 0]
      dsc = "Bezier curve oscillator."
  in u_std_mce 1 (osc_U "Bezier" [kr,ar] ar i 1 dsc False)

rDelayMap_dsc :: U
rDelayMap_dsc =
    let i = [I "bufnum" 0
            ,I "input" 0
            ,I "dynamic" 0
            ,I "mapArray" 0]
    in u_flt 1 (u_std_mce 1 (osc_U "RDelayMap" [ar] ar i 1 "Network of delay line maps" False))

rDelaySet_dsc :: U
rDelaySet_dsc =
    let i = [I "input" 0
            ,I "setArray" 0]
    in u_flt 0 (u_std_mce 1 (osc_U "RDelaySet" [ar] ar i 1 "Delay set (RTAlloc)" False))

rDelaySetB_dsc :: U
rDelaySetB_dsc =
    let i = [I "buffer" 0
            ,I "input" 0
            ,I "setArray" 0]
    in u_flt 1 (u_std_mce 1 (osc_U "RDelaySetB" [ar] ar i 1 "Delay set (Buffer)" False))

rdl_dsc :: U
rdl_dsc =
    let i = [I "inputs" 0]
    in u_ar (u_std_mce 1 (u_nc_input (osc_U "RDL" [ar] ar i 1 "Dynamic library host" False)))

dx7_dsc :: U
dx7_dsc =
  default_u
  {ugen_name = "DX7"
  ,ugen_operating_rates = [ar]
  ,ugen_inputs = [I "bufnum" 0
                 ,I "on" 0 -- keydown tr
                 ,I "off" 0 -- keyup tr
                 ,I "data" 0 -- data read tr
                 ,I "vc" 0
                 ,I "mnn" 60
                 ,I "vel" 99
                 ,I "pw" 0
                 ,I "mw" 0
                 ,I "bc" 0
                 ,I "fc" 0]
  ,ugen_summary = "DX7 (MFSA/DEXED)"
  ,ugen_outputs = Just 1}

dx7Env_dsc :: U
dx7Env_dsc =
  default_u
  {ugen_name = "DX7Env"
  ,ugen_operating_rates = [ar]
  ,ugen_inputs = [I "gate" 0
                 ,I "data" 0
                 ,I "r1" 99,I "r2" 99,I "r3" 99,I "r4" 99
                 ,I "l1" 99,I "l2" 99,I "l3" 99,I "l4" 00
                 ,I "ol" 0]
  ,ugen_summary = "DX7Env"
  ,ugen_outputs = Just 1}

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
    in u_ar (osc_U "RFreezer" [ar] ar i 1 "Concurrent loops at signal buffer" False)

rLagC_dsc :: U
rLagC_dsc =
  let i = [I "in" 0
          ,I "timeUp" 0.1
          ,I "curveUp" 0
          ,I "timeDown" 0.1
          ,I "curveDown" 0]
  in default_u {ugen_name = "RLagC"
               ,ugen_operating_rates = [kr]
               ,ugen_inputs = i
               ,ugen_summary = "LagUD variant with curve inputs."
               ,ugen_filter = Just [0]
               ,ugen_outputs = Just 1
               }

rObxdFilter_dsc :: U
rObxdFilter_dsc =
    let i = [I "in" 0
            ,I "cutoff" 440.0
            ,I "resonance" 0.0
            ,I "multimode" 0.5
            ,I "bandpass" 0.0
            ,I "fourpole" 0.0]
    in u_flt 0 (osc_U "RObxdFilter" [ar] ar i 1 "Obxd 12/24-dB multi-mode filter" False)

rpvDecayTbl_dsc :: U
rpvDecayTbl_dsc =
    let i = [I "fft_buf" 0
            ,I "decay_rate_buf" 0
            ,I "history_buf" 0]
    in osc_U "RPVDecayTbl" [kr] kr i 1 "Decay bin magnitudes according to multipliers in table." False

-- | (k,name,default-value,meta-data)
type Ctl_Param = (Int,String,Double,Control_Meta_T5 Double)

param_rctl_bus_pp :: Ctl_Param -> String
param_rctl_bus_pp (k,nm,def,meta) =
  let cs = c_meta_cs_pp meta def
  in printf "c[%d].setup(\"%s\",%s,%.4f,%d);" k nm cs def k

param_rctl_node_pp :: Node_Id -> Ctl_Param -> String
param_rctl_node_pp nid (k,nm,def,meta) =
  let cs = c_meta_cs_pp meta def
  in printf "c[%d].setup(\"%s\",%s,%.4f,nil,%d,\"%s\");" k nm cs def nid nm

-- | Parameters, I with meta.
--
-- > putStrLn $ unlines $ map param_rctl_bus_pp rShufflerB_param
rShufflerB_param :: [Ctl_Param]
rShufflerB_param =
  let t4 a b c d = (a,b,c,d)
  in [t4 0 "bufnum" 0 (0,100,"linear",1,"")
     ,t4 1 "readLocationMinima" 0 (0,1,"linear",0.01,"")
     ,t4 2 "readLocationMaxima" 0 (0,1,"linear",0.01,"")
     ,t4 3 "readIncrementMinima" 1 (0.5,2,"linear",0.01,"")
     ,t4 4 "readIncrementMaxima" 1 (0.5,2,"linear",0.01,"")
     ,t4 5 "durationMinima" 0.005 (0.001,0.500,"linear",0.005,"s")
     ,t4 6 "durationMaxima" 0.500 (0.001,0.500,"linear",0.005,"s")
     ,t4 7 "envelopeAmplitudeMinima" 0.5 (0.05,1.0,"exponential",0.01,"")
     ,t4 8 "envelopeAmplitudeMaxima" 0.5 (0.05,1.0,"exponential",0.01,"")
     ,t4 9 "envelopeShapeMinima" 0.5 (0,1,"linear",0.01,"")
     ,t4 10 "envelopeShapeMaxima" 0.5 (0,1,"linear",0.01,"")
     ,t4 11 "envelopeSkewMinima" 0.5 (0,1,"linear",0.01,"")
     ,t4 12 "envelopeSkewMaxima" 0.5 (0,1,"linear",0.01,"")
     ,t4 13 "stereoLocationMinima" 0 (0,1,"linear",0.01,"")
     ,t4 14 "stereoLocationMaxima" 1 (0,1,"linear",0.01,"")
     ,t4 15 "interOffsetTimeMinima" 0.05 (0.005,0.500,"linear",0.005,"s")
     ,t4 16 "interOffsetTimeMaxima" 0.05 (0.001,0.500,"linear",0.005,"s")
     ,t4 17 "ftableReadLocationIncrement" 1 (0,1,"linear",0.01,"")
     ,t4 18 "readIncrementQuanta" 0 (0,0.5,"linear",0.01,"s")
     ,t4 19 "interOffsetTimeQuanta" 0 (0,0.01,"linear",0.0001,"s")]

rShufflerB_dsc :: U
rShufflerB_dsc =
 let i = map (\(_k,nm,def,_rng) -> I nm def) rShufflerB_param
 in osc_U "RShufflerB" [ar] ar i 2 "Signal shuffler (Buffer)" False

rShufflerL_dsc :: U
rShufflerL_dsc =
    let i = [I "in" 0
            ,I "fragmentSize" 0.005
            ,I "maxDelay" 0.005]
    in u_flt 0 (osc_U "RShufflerL" [ar] ar i 1 "Signal shuffler (Linear)" False)

rTraceRd_dsc :: U
rTraceRd_dsc =
    let i = [I "bufnum" 0
            ,I "degree" 4
            ,I "index" 0
            ,I "access" 1]
    in osc_U "RTraceRd" [kr,ar] ar i 1 "Read trace buffer" False

rPlayTrace_dsc :: U
rPlayTrace_dsc =
    let i = [I "bufnum" 0
            ,I "degree" 4
            ,I "rate" 0
            ,I "access" 1]
    in osc_U "RPlayTrace" [kr,ar] ar i 1 "Play trace buffer" False

tScramble_dsc :: U
tScramble_dsc =
    default_u {ugen_name = "TScramble"
              ,ugen_operating_rates = [ir,kr]
              ,ugen_inputs = [I "trigger" 0,I "inputs" 0]
              ,ugen_summary = "Scramble inputs on trigger."
              ,ugen_std_mce = 1
              ,ugen_nc_mce = Just 0
              ,ugen_filter = Just [0]
              ,ugen_nondet = True
              }

tRandN_dsc :: U
tRandN_dsc =
    default_u {ugen_name = "TRandN"
              ,ugen_operating_rates = [kr]
              ,ugen_inputs = [I "lo" 0,I "hi" 1,I "trigger" 0]
              ,ugen_summary = "Generate new random values on trigger."
              ,ugen_nc_input = True
              ,ugen_filter = Just [2]
              ,ugen_nondet = True
              }

tExpRandN_dsc :: U
tExpRandN_dsc =
    default_u {ugen_name = "TExpRandN"
              ,ugen_operating_rates = [kr]
              ,ugen_inputs = [I "lo" 0,I "hi" 1,I "trigger" 0]
              ,ugen_summary = "Generate new exponentially distributed random values on trigger."
              ,ugen_nc_input = True
              ,ugen_filter = Just [2]
              ,ugen_nondet = True
              }

rSmplrIndex_dsc :: U
rSmplrIndex_dsc =
    default_u {ugen_name = "RSmplrIndex"
              ,ugen_operating_rates = [kr]
              ,ugen_inputs = [I "buf" 0,I "size" 0,I "mnn" 60]
              ,ugen_summary = "Find buffer index and rate multiplier given table of MNN."
              ,ugen_outputs = Just 2
              }

rsvfbp_dsc :: U
rsvfbp_dsc =
    let i = [I "in" 0,I "freq" 440.0,I "q" 0.0]
    in u_flt 0 (osc_U "RSVFBP" [kr,ar] ar i 1 "Digital State-Variable Filter (Band-pass)" False)

rsvfhp_dsc :: U
rsvfhp_dsc =
    let i = [I "in" 0,I "freq" 440.0,I "q" 0.0]
    in u_flt 0 (osc_U "RSVFHP" [kr,ar] ar i 1 "Digital State-Variable Filter (High-pass)" False)

rsvflp_dsc :: U
rsvflp_dsc =
    let i = [I "in" 0,I "freq" 440.0,I "q" 0.0]
    in u_flt 0 (osc_U "RSVFLP" [kr,ar] ar i 1 "Digital State-Variable Filter (Low-pass)" False)

-- * Db

rdu_db :: [U]
rdu_db =
    [pv_Split_dsc
    ,bezier_dsc
    ,dx7Env_dsc
    ,dx7_dsc
    ,rDelayMap_dsc
    ,rDelaySetB_dsc
    ,rDelaySet_dsc
    ,dustRange_dsc
    ,expRandN_dsc
    ,rFreezer_dsc
    ,rLagC_dsc
    ,linRandN_dsc
    ,rObxdFilter_dsc
    ,rPlayTrace_dsc
    ,randN_dsc
    ,rShufflerB_dsc
    ,rShufflerL_dsc
    ,rSmplrIndex_dsc
    ,rsvfbp_dsc
    ,rsvfhp_dsc
    ,rsvflp_dsc
    ,rTraceRd_dsc
    ,rdl_dsc
    ,iRandN_dsc
    ,rpvDecayTbl_dsc
    ,tExpRandN_dsc
    ,tRandN_dsc
    ,tScramble_dsc
    ]

gen_hs_bindings :: IO ()
gen_hs_bindings = let f = putStrLn . unlines . Haskell.u_gen_binding_set in mapM_ f rdu_db

gen_scheme_bindings :: IO ()
gen_scheme_bindings = let f = putStrLn . Scheme.scheme_u_gen_binding id in mapM_ f rdu_db
