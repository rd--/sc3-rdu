-- | Bindings (AUTOGEN), see "Sound.SC3.UGen.External.RDU"
module Sound.SC3.UGen.Bindings.DB.RDU where

import Sound.SC3.Common.Rate
import Sound.SC3.Common.UId
import Sound.SC3.UGen.Type
import Sound.SC3.UGen.UGen

import Sound.SC3.UGen.Analysis
import Sound.SC3.UGen.Bindings.DB

-- | Copies spectral frame (ie. PV_Copy with two outputs).
--
--  PV_Split [ControlRate] bufferA=0 bufferB=0
pv_Split :: UGen -> UGen -> UGen
pv_Split bufferA bufferB = mkUGen Nothing [ControlRate] (Left ControlRate) "PV_Split" [bufferA,bufferB] Nothing 2 (Special 0) NoId

-- | Bezier curve oscillator.
--
--  RBezier [ControlRate,AudioRate] haltAfter=100 dx=0.0001 freq=440 phase=0 *param=0;    MCE=1
rBezier :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rBezier rate haltAfter dx freq phase param = mkUGen Nothing [ControlRate,AudioRate] (Left rate) "RBezier" [haltAfter,dx,freq,phase] (Just [param]) 1 (Special 0) NoId

-- | DX7Env
--
--  RDX7Env [AudioRate] gate=0 data=0 r1=99 r2=99 r3=99 r4=99 l1=99 l2=99 l3=99 l4=0 ol=0
rdx7Env :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rdx7Env rate gate_ data_ r1 r2 r3 r4 l1 l2 l3 l4 ol = mkUGen Nothing [AudioRate] (Left rate) "RDX7Env" [gate_,data_,r1,r2,r3,r4,l1,l2,l3,l4,ol] Nothing 1 (Special 0) NoId

-- | DX7 (MFSA/DEXED)
--
--  RDX7 [AudioRate] bufnum=0 on=0 off=0 data=0 vc=0 mnn=60 vel=99 pw=0 mw=0 bc=0 fc=0
rdx7 :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rdx7 rate bufnum on off data_ vc mnn vel pw mw bc fc = mkUGen Nothing [AudioRate] (Left rate) "RDX7" [bufnum,on,off,data_,vc,mnn,vel,pw,mw,bc,fc] Nothing 1 (Special 0) NoId

-- | Network of delay line maps
--
--  RDelayMap [AudioRate] bufnum=0 input=0 dynamic=0 *mapArray=0;    MCE=1, FILTER: TRUE
rDelayMap :: UGen -> UGen -> UGen -> UGen -> UGen
rDelayMap bufnum input dynamic mapArray = mkUGen Nothing [AudioRate] (Right [1]) "RDelayMap" [bufnum,input,dynamic] (Just [mapArray]) 1 (Special 0) NoId

-- | Delay set (Buffer)
--
--  RDelaySetB [AudioRate] buffer=0 input=0 *setArray=0;    MCE=1, FILTER: TRUE
rDelaySetB :: UGen -> UGen -> UGen -> UGen
rDelaySetB buffer input setArray = mkUGen Nothing [AudioRate] (Right [1]) "RDelaySetB" [buffer,input] (Just [setArray]) 1 (Special 0) NoId

-- | Delay set (RTAlloc)
--
--  RDelaySet [AudioRate] input=0 *setArray=0;    MCE=1, FILTER: TRUE
rDelaySet :: UGen -> UGen -> UGen
rDelaySet input setArray = mkUGen Nothing [AudioRate] (Right [0]) "RDelaySet" [input] (Just [setArray]) 1 (Special 0) NoId

-- | Range variant of Dust
--
--  RDustR [AudioRate] lo=0.0001 hi=1;    NONDET
rDustRId :: ID a => a -> Rate -> UGen -> UGen -> UGen
rDustRId z rate lo hi = mkUGen Nothing [AudioRate] (Left rate) "RDustR" [lo,hi] Nothing 1 (Special 0) (toUId z)

-- | Range variant of Dust
--
--  RDustR [AudioRate] lo=0.0001 hi=1;    NONDET
rDustR :: Rate -> UGen -> UGen -> UGen
rDustR rate lo hi = mkUGen Nothing [AudioRate] (Left rate) "RDustR" [lo,hi] Nothing 1 (Special 0) (toUId (idGensym ()))

-- | Multi-channel variant of ExpRand
--
--  RExpRandN [InitialisationRate] lo=0.0001 hi=1;    NC INPUT: True, NONDET
rExpRandNId :: ID a => Int -> a -> UGen -> UGen -> UGen
rExpRandNId numChannels z lo hi = mkUGen Nothing [InitialisationRate] (Left InitialisationRate) "RExpRandN" [lo,hi] Nothing numChannels (Special 0) (toUId z)

-- | Multi-channel variant of ExpRand
--
--  RExpRandN [InitialisationRate] lo=0.0001 hi=1;    NC INPUT: True, NONDET
rExpRandN :: Int -> UGen -> UGen -> UGen
rExpRandN numChannels lo hi = mkUGen Nothing [InitialisationRate] (Left InitialisationRate) "RExpRandN" [lo,hi] Nothing numChannels (Special 0) (toUId (idGensym ()))

-- | Concurrent loops at signal buffer
--
--  RFreezer [AudioRate] bufnum=0 left=0 right=1 gain=0.1 increment=1 incrementOffset=0 incrementRandom=0.05 rightRandom=0.05 syncPhaseTrigger=0 randomizePhaseTrigger=0 numberOfLoops=6
rFreezer :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rFreezer bufnum left right gain increment incrementOffset incrementRandom rightRandom syncPhaseTrigger randomizePhaseTrigger numberOfLoops = mkUGen Nothing [AudioRate] (Left AudioRate) "RFreezer" [bufnum,left,right,gain,increment,incrementOffset,incrementRandom,rightRandom,syncPhaseTrigger,randomizePhaseTrigger,numberOfLoops] Nothing 1 (Special 0) NoId

-- | LagUD variant with curve inputs.
--
--  RLagC [ControlRate] in=0 timeUp=0.1 curveUp=0 timeDown=0.1 curveDown=0;    FILTER: TRUE
rLagC :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rLagC in_ timeUp curveUp timeDown curveDown = mkUGen Nothing [ControlRate] (Right [0]) "RLagC" [in_,timeUp,curveUp,timeDown,curveDown] Nothing 1 (Special 0) NoId

-- | Multi-channel variant of LinRand
--
--  RLinRandN [InitialisationRate] lo=0.0001 hi=1 minmax=0;    NC INPUT: True, NONDET
rLinRandNId :: ID a => Int -> a -> UGen -> UGen -> UGen -> UGen
rLinRandNId numChannels z lo hi minmax = mkUGen Nothing [InitialisationRate] (Left InitialisationRate) "RLinRandN" [lo,hi,minmax] Nothing numChannels (Special 0) (toUId z)

-- | Multi-channel variant of LinRand
--
--  RLinRandN [InitialisationRate] lo=0.0001 hi=1 minmax=0;    NC INPUT: True, NONDET
rLinRandN :: Int -> UGen -> UGen -> UGen -> UGen
rLinRandN numChannels lo hi minmax = mkUGen Nothing [InitialisationRate] (Left InitialisationRate) "RLinRandN" [lo,hi,minmax] Nothing numChannels (Special 0) (toUId (idGensym ()))

-- | Obxd 12/24-dB multi-mode filter
--
--  RObxdFilter [AudioRate] in=0 cutoff=440 resonance=0 multimode=0.5 bandpass=0 fourpole=0;    FILTER: TRUE
rObxdFilter :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rObxdFilter in_ cutoff resonance multimode bandpass fourpole = mkUGen Nothing [AudioRate] (Right [0]) "RObxdFilter" [in_,cutoff,resonance,multimode,bandpass,fourpole] Nothing 1 (Special 0) NoId

-- | Play trace buffer
--
--  RPlayTrace [ControlRate,AudioRate] bufnum=0 degree=4 rate=0 access=1
rPlayTrace :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen
rPlayTrace rate bufnum degree rate_ access = mkUGen Nothing [ControlRate,AudioRate] (Left rate) "RPlayTrace" [bufnum,degree,rate_,access] Nothing 1 (Special 0) NoId

-- | Multi-channel variant of Rand
--
--  RRandN [InitialisationRate] lo=0.0001 hi=1;    NC INPUT: True, NONDET
rRandNId :: ID a => Int -> a -> UGen -> UGen -> UGen
rRandNId numChannels z lo hi = mkUGen Nothing [InitialisationRate] (Left InitialisationRate) "RRandN" [lo,hi] Nothing numChannels (Special 0) (toUId z)

-- | Multi-channel variant of Rand
--
--  RRandN [InitialisationRate] lo=0.0001 hi=1;    NC INPUT: True, NONDET
rRandN :: Int -> UGen -> UGen -> UGen
rRandN numChannels lo hi = mkUGen Nothing [InitialisationRate] (Left InitialisationRate) "RRandN" [lo,hi] Nothing numChannels (Special 0) (toUId (idGensym ()))

-- | Signal shuffler (Buffer)
--
--  RShufflerB [AudioRate] bufnum=0 readLocationMinima=0 readLocationMaxima=0 readIncrementMinima=1 readIncrementMaxima=1 durationMinima=0.005 durationMaxima=0.5 envelopeAmplitudeMinima=0.5 envelopeAmplitudeMaxima=0.5 envelopeShapeMinima=0.5 envelopeShapeMaxima=0.5 envelopeSkewMinima=0.5 envelopeSkewMaxima=0.5 stereoLocationMinima=0 stereoLocationMaxima=1 interOffsetTimeMinima=0.05 interOffsetTimeMaxima=0.05 ftableReadLocationIncrement=1 readIncrementQuanta=0 interOffsetTimeQuanta=0
rShufflerB :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rShufflerB bufnum readLocationMinima readLocationMaxima readIncrementMinima readIncrementMaxima durationMinima durationMaxima envelopeAmplitudeMinima envelopeAmplitudeMaxima envelopeShapeMinima envelopeShapeMaxima envelopeSkewMinima envelopeSkewMaxima stereoLocationMinima stereoLocationMaxima interOffsetTimeMinima interOffsetTimeMaxima ftableReadLocationIncrement readIncrementQuanta interOffsetTimeQuanta = mkUGen Nothing [AudioRate] (Left AudioRate) "RShufflerB" [bufnum,readLocationMinima,readLocationMaxima,readIncrementMinima,readIncrementMaxima,durationMinima,durationMaxima,envelopeAmplitudeMinima,envelopeAmplitudeMaxima,envelopeShapeMinima,envelopeShapeMaxima,envelopeSkewMinima,envelopeSkewMaxima,stereoLocationMinima,stereoLocationMaxima,interOffsetTimeMinima,interOffsetTimeMaxima,ftableReadLocationIncrement,readIncrementQuanta,interOffsetTimeQuanta] Nothing 2 (Special 0) NoId

-- | Signal shuffler (Linear)
--
--  RShufflerL [AudioRate] in=0 fragmentSize=0.005 maxDelay=0.005;    FILTER: TRUE
rShufflerL :: UGen -> UGen -> UGen -> UGen
rShufflerL in_ fragmentSize maxDelay = mkUGen Nothing [AudioRate] (Right [0]) "RShufflerL" [in_,fragmentSize,maxDelay] Nothing 1 (Special 0) NoId

-- | Find buffer index and rate multiplier given table of MNN.
--
--  RSmplrIndex [ControlRate] buf=0 size=0 mnn=60
rSmplrIndex :: Rate -> UGen -> UGen -> UGen -> UGen
rSmplrIndex rate buf size mnn = mkUGen Nothing [ControlRate] (Left rate) "RSmplrIndex" [buf,size,mnn] Nothing 2 (Special 0) NoId

-- | Digital State-Variable Filter (Band-pass)
--
--  RSVFBP [ControlRate,AudioRate] in=0 freq=440 q=0;    FILTER: TRUE
rsvfbp :: UGen -> UGen -> UGen -> UGen
rsvfbp in_ freq q = mkUGen Nothing [ControlRate,AudioRate] (Right [0]) "RSVFBP" [in_,freq,q] Nothing 1 (Special 0) NoId

-- | Digital State-Variable Filter (High-pass)
--
--  RSVFHP [ControlRate,AudioRate] in=0 freq=440 q=0;    FILTER: TRUE
rsvfhp :: UGen -> UGen -> UGen -> UGen
rsvfhp in_ freq q = mkUGen Nothing [ControlRate,AudioRate] (Right [0]) "RSVFHP" [in_,freq,q] Nothing 1 (Special 0) NoId

-- | Digital State-Variable Filter (Low-pass)
--
--  RSVFLP [ControlRate,AudioRate] in=0 freq=440 q=0;    FILTER: TRUE
rsvflp :: UGen -> UGen -> UGen -> UGen
rsvflp in_ freq q = mkUGen Nothing [ControlRate,AudioRate] (Right [0]) "RSVFLP" [in_,freq,q] Nothing 1 (Special 0) NoId

-- | Read trace buffer
--
--  RTraceRd [ControlRate,AudioRate] bufnum=0 degree=4 index=0 access=1
rTraceRd :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen
rTraceRd rate bufnum degree index_ access = mkUGen Nothing [ControlRate,AudioRate] (Left rate) "RTraceRd" [bufnum,degree,index_,access] Nothing 1 (Special 0) NoId

-- | Dynamic library host
--
--  RDL [AudioRate] *inputs=0;    MCE=1, NC INPUT: True
rdl :: Int -> UGen -> UGen
rdl numChannels inputs = mkUGen Nothing [AudioRate] (Left AudioRate) "RDL" [] (Just [inputs]) numChannels (Special 0) NoId

-- | Multi-channel variant of irand
--
--  RirandN [InitialisationRate] lo=0.0001 hi=1;    NC INPUT: True, NONDET
rirandNId :: ID a => Int -> a -> UGen -> UGen -> UGen
rirandNId numChannels z lo hi = mkUGen Nothing [InitialisationRate] (Left InitialisationRate) "RirandN" [lo,hi] Nothing numChannels (Special 0) (toUId z)

-- | Multi-channel variant of irand
--
--  RirandN [InitialisationRate] lo=0.0001 hi=1;    NC INPUT: True, NONDET
rirandN :: Int -> UGen -> UGen -> UGen
rirandN numChannels lo hi = mkUGen Nothing [InitialisationRate] (Left InitialisationRate) "RirandN" [lo,hi] Nothing numChannels (Special 0) (toUId (idGensym ()))

-- | Decay bin magnitudes according to multipliers in table.
--
--  RPVDecayTbl [ControlRate] fft_buf=0 decay_rate_buf=0 history_buf=0
rpvDecayTbl :: Rate -> UGen -> UGen -> UGen -> UGen
rpvDecayTbl rate fft_buf decay_rate_buf history_buf = mkUGen Nothing [ControlRate] (Left rate) "RPVDecayTbl" [fft_buf,decay_rate_buf,history_buf] Nothing 1 (Special 0) NoId

-- | Generate new exponentially distributed random values on trigger.
--
--  RTExpRandN [ControlRate] lo=0 hi=1 trigger=0;    NC INPUT: True, FILTER: TRUE, NONDET
rtExpRandNId :: ID a => Int -> a -> UGen -> UGen -> UGen -> UGen
rtExpRandNId numChannels z lo hi trigger = mkUGen Nothing [ControlRate] (Right [2]) "RTExpRandN" [lo,hi,trigger] Nothing numChannels (Special 0) (toUId z)

-- | Generate new exponentially distributed random values on trigger.
--
--  RTExpRandN [ControlRate] lo=0 hi=1 trigger=0;    NC INPUT: True, FILTER: TRUE, NONDET
rtExpRandN :: Int -> UGen -> UGen -> UGen -> UGen
rtExpRandN numChannels lo hi trigger = mkUGen Nothing [ControlRate] (Right [2]) "RTExpRandN" [lo,hi,trigger] Nothing numChannels (Special 0) (toUId (idGensym ()))

-- | Generate new random values on trigger.
--
--  RTRandN [ControlRate] lo=0 hi=1 trigger=0;    NC INPUT: True, FILTER: TRUE, NONDET
rtRandNId :: ID a => Int -> a -> UGen -> UGen -> UGen -> UGen
rtRandNId numChannels z lo hi trigger = mkUGen Nothing [ControlRate] (Right [2]) "RTRandN" [lo,hi,trigger] Nothing numChannels (Special 0) (toUId z)

-- | Generate new random values on trigger.
--
--  RTRandN [ControlRate] lo=0 hi=1 trigger=0;    NC INPUT: True, FILTER: TRUE, NONDET
rtRandN :: Int -> UGen -> UGen -> UGen -> UGen
rtRandN numChannels lo hi trigger = mkUGen Nothing [ControlRate] (Right [2]) "RTRandN" [lo,hi,trigger] Nothing numChannels (Special 0) (toUId (idGensym ()))

-- | Scramble inputs on trigger.
--
--  RTScramble [InitialisationRate,ControlRate] trigger=0 *inputs=0;    MCE=1, FILTER: TRUE, NONDET
rtScrambleId :: ID a => a -> UGen -> UGen -> UGen
rtScrambleId z trigger inputs = mkUGen Nothing [InitialisationRate,ControlRate] (Right [0]) "RTScramble" [trigger] (Just [inputs]) (length (mceChannels inputs) + 0) (Special 0) (toUId z)

-- | Scramble inputs on trigger.
--
--  RTScramble [InitialisationRate,ControlRate] trigger=0 *inputs=0;    MCE=1, FILTER: TRUE, NONDET
rtScramble :: UGen -> UGen -> UGen
rtScramble trigger inputs = mkUGen Nothing [InitialisationRate,ControlRate] (Right [0]) "RTScramble" [trigger] (Just [inputs]) (length (mceChannels inputs) + 0) (Special 0) (toUId (idGensym ()))

-- * Variants

-- | Variant that unpacks the output /mce/ node.
pv_split :: UGen -> UGen -> (UGen,UGen)
pv_split a b =
    case mceChannels (pv_Split a b) of
      [p,q] -> (p,q)
      _ -> error "pv_split"

-- | A 'pv_Split' variant, like 'ffta', that allocates a 'localBuf' by
-- tracing the input graph to locate the parent @FFT@ or @PV_Split@
-- node.
pv_SplitaId :: ID i => i -> UGen -> UGen
pv_SplitaId z u =
    case pv_track_nframes u of
      Left err -> error err
      Right nf -> let b = localBufId z nf 1 in pv_Split u b

-- | Variant that unpacks the output /mce/ node.
pv_splitaId :: ID i => i -> UGen -> (UGen,UGen)
pv_splitaId z u =
    case mceChannels (pv_SplitaId z u) of
      [p,q] -> (p,q)
      _ -> error "pv_splita"
