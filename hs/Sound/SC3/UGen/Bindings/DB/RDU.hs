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
--  PV_Split [KR] bufferA=0.0 bufferB=0.0
pv_Split :: UGen -> UGen -> UGen
pv_Split bufferA bufferB = mkUGen Nothing [KR] (Left KR) "PV_Split" [bufferA,bufferB] Nothing 2 (Special 0) NoId

-- | Bezier curve oscillator.
--
--  RBezier [KR,AR] haltAfter=100.0 dx=1.0e-4 freq=440.0 phase=0.0 *param=0.0;    MCE=1
rBezier :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rBezier rate haltAfter dx freq phase param = mkUGen Nothing [KR,AR] (Left rate) "RBezier" [haltAfter,dx,freq,phase] (Just [param]) 1 (Special 0) NoId

-- | DX7Env
--
--  RDX7Env [AR] gate=0.0 data=0.0 r1=99.0 r2=99.0 r3=99.0 r4=99.0 l1=99.0 l2=99.0 l3=99.0 l4=0.0 ol=0.0
rdx7Env :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rdx7Env rate gate_ data_ r1 r2 r3 r4 l1 l2 l3 l4 ol = mkUGen Nothing [AR] (Left rate) "RDX7Env" [gate_,data_,r1,r2,r3,r4,l1,l2,l3,l4,ol] Nothing 1 (Special 0) NoId

-- | DX7 (MFSA/DEXED)
--
--  RDX7 [AR] bufnum=0.0 on=0.0 off=0.0 data=0.0 vc=0.0 mnn=60.0 vel=99.0 pw=0.0 mw=0.0 bc=0.0 fc=0.0
rdx7 :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rdx7 rate bufnum on off data_ vc mnn vel pw mw bc fc = mkUGen Nothing [AR] (Left rate) "RDX7" [bufnum,on,off,data_,vc,mnn,vel,pw,mw,bc,fc] Nothing 1 (Special 0) NoId

-- | Network of delay line maps
--
--  RDelayMap [AR] bufnum=0.0 input=0.0 dynamic=0.0 *mapArray=0.0;    MCE=1, FILTER: TRUE
rDelayMap :: UGen -> UGen -> UGen -> UGen -> UGen
rDelayMap bufnum input dynamic mapArray = mkUGen Nothing [AR] (Right [1]) "RDelayMap" [bufnum,input,dynamic] (Just [mapArray]) 1 (Special 0) NoId

-- | Delay set (Buffer)
--
--  RDelaySetB [AR] buffer=0.0 input=0.0 *setArray=0.0;    MCE=1, FILTER: TRUE
rDelaySetB :: UGen -> UGen -> UGen -> UGen
rDelaySetB buffer input setArray = mkUGen Nothing [AR] (Right [1]) "RDelaySetB" [buffer,input] (Just [setArray]) 1 (Special 0) NoId

-- | Delay set (RTAlloc)
--
--  RDelaySet [AR] input=0.0 *setArray=0.0;    MCE=1, FILTER: TRUE
rDelaySet :: UGen -> UGen -> UGen
rDelaySet input setArray = mkUGen Nothing [AR] (Right [0]) "RDelaySet" [input] (Just [setArray]) 1 (Special 0) NoId

-- | Range variant of Dust
--
--  RDustR [AR] lo=1.0e-4 hi=1.0;    NONDET
rDustR :: ID a => a -> Rate -> UGen -> UGen -> UGen
rDustR z rate lo hi = mkUGen Nothing [AR] (Left rate) "RDustR" [lo,hi] Nothing 1 (Special 0) (toUId z)

-- | Multi-channel variant of ExpRand
--
--  RExpRandN [IR] lo=1.0e-4 hi=1.0;    NC INPUT: True, NONDET
rExpRandN :: ID a => Int -> a -> UGen -> UGen -> UGen
rExpRandN numChannels z lo hi = mkUGen Nothing [IR] (Left IR) "RExpRandN" [lo,hi] Nothing numChannels (Special 0) (toUId z)

-- | Concurrent loops at signal buffer
--
--  RFreezer [AR] bufnum=0.0 left=0.0 right=1.0 gain=0.1 increment=1.0 incrementOffset=0.0 incrementRandom=5.0e-2 rightRandom=5.0e-2 syncPhaseTrigger=0.0 randomizePhaseTrigger=0.0 numberOfLoops=6.0
rFreezer :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rFreezer bufnum left right gain increment incrementOffset incrementRandom rightRandom syncPhaseTrigger randomizePhaseTrigger numberOfLoops = mkUGen Nothing [AR] (Left AR) "RFreezer" [bufnum,left,right,gain,increment,incrementOffset,incrementRandom,rightRandom,syncPhaseTrigger,randomizePhaseTrigger,numberOfLoops] Nothing 1 (Special 0) NoId

-- | Digital State-Variable Filter (band-pass)
--
--  RSVFBP [KR,AR] in=0.0 freq=440.0 q=0.0;    FILTER: TRUE
rsvfbp :: UGen -> UGen -> UGen -> UGen
rsvfbp in_ freq q = mkUGen Nothing [KR,AR] (Right [0]) "RSVFBP" [in_,freq,q] Nothing 1 (Special 0) NoId

-- | Digital State-Variable Filter (High-pass)
--
--  RSVFHP [KR,AR] in=0.0 freq=440.0 q=0.0;    FILTER: TRUE
rsvfhp :: UGen -> UGen -> UGen -> UGen
rsvfhp in_ freq q = mkUGen Nothing [KR,AR] (Right [0]) "RSVFHP" [in_,freq,q] Nothing 1 (Special 0) NoId

-- | Digital State-Variable Filter (Low-pass)
--
--  RSVFLP [KR,AR] in=0.0 freq=440.0 q=0.0;    FILTER: TRUE
rsvflp :: UGen -> UGen -> UGen -> UGen
rsvflp in_ freq q = mkUGen Nothing [KR,AR] (Right [0]) "RSVFLP" [in_,freq,q] Nothing 1 (Special 0) NoId

-- | LagUD variant with curve inputs.
--
--  RLagC [KR] in=0.0 timeUp=0.1 curveUp=0.0 timeDown=0.1 curveDown=0.0;    FILTER: TRUE
rLagC :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rLagC in_ timeUp curveUp timeDown curveDown = mkUGen Nothing [KR] (Right [0]) "RLagC" [in_,timeUp,curveUp,timeDown,curveDown] Nothing 1 (Special 0) NoId

-- | Multi-channel variant of LinRand
--
--  RLinRandN [IR] lo=1.0e-4 hi=1.0 minmax=0.0;    NC INPUT: True, NONDET
rLinRandN :: ID a => Int -> a -> UGen -> UGen -> UGen -> UGen
rLinRandN numChannels z lo hi minmax = mkUGen Nothing [IR] (Left IR) "RLinRandN" [lo,hi,minmax] Nothing numChannels (Special 0) (toUId z)

-- | Obxd 12/24-dB multi-mode filter
--
--  RObxdFilter [AR] in=0.0 cutoff=440.0 resonance=0.0 multimode=0.5 bandpass=0.0 fourpole=0.0;    FILTER: TRUE
rObxdFilter :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rObxdFilter in_ cutoff resonance multimode bandpass fourpole = mkUGen Nothing [AR] (Right [0]) "RObxdFilter" [in_,cutoff,resonance,multimode,bandpass,fourpole] Nothing 1 (Special 0) NoId

-- | Play trace buffer
--
--  RPlayTrace [KR,AR] bufnum=0.0 degree=4.0 rate=0.0 access=1.0
rPlayTrace :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen
rPlayTrace rate bufnum degree rate_ access = mkUGen Nothing [KR,AR] (Left rate) "RPlayTrace" [bufnum,degree,rate_,access] Nothing 1 (Special 0) NoId

-- | Multi-channel variant of Rand
--
--  RRandN [IR] lo=1.0e-4 hi=1.0;    NC INPUT: True, NONDET
rRandN :: ID a => Int -> a -> UGen -> UGen -> UGen
rRandN numChannels z lo hi = mkUGen Nothing [IR] (Left IR) "RRandN" [lo,hi] Nothing numChannels (Special 0) (toUId z)

-- | Signal shuffler (Buffer)
--
--  RShufflerB [AR] bufnum=0.0 readLocationMinima=0.0 readLocationMaxima=0.0 readIncrementMinima=1.0 readIncrementMaxima=1.0 durationMinima=5.0e-3 durationMaxima=0.5 envelopeAmplitudeMinima=0.5 envelopeAmplitudeMaxima=0.5 envelopeShapeMinima=0.5 envelopeShapeMaxima=0.5 envelopeSkewMinima=0.5 envelopeSkewMaxima=0.5 stereoLocationMinima=0.0 stereoLocationMaxima=1.0 interOffsetTimeMinima=5.0e-2 interOffsetTimeMaxima=5.0e-2 ftableReadLocationIncrement=1.0 readIncrementQuanta=0.0 interOffsetTimeQuanta=0.0
rShufflerB :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rShufflerB bufnum readLocationMinima readLocationMaxima readIncrementMinima readIncrementMaxima durationMinima durationMaxima envelopeAmplitudeMinima envelopeAmplitudeMaxima envelopeShapeMinima envelopeShapeMaxima envelopeSkewMinima envelopeSkewMaxima stereoLocationMinima stereoLocationMaxima interOffsetTimeMinima interOffsetTimeMaxima ftableReadLocationIncrement readIncrementQuanta interOffsetTimeQuanta = mkUGen Nothing [AR] (Left AR) "RShufflerB" [bufnum,readLocationMinima,readLocationMaxima,readIncrementMinima,readIncrementMaxima,durationMinima,durationMaxima,envelopeAmplitudeMinima,envelopeAmplitudeMaxima,envelopeShapeMinima,envelopeShapeMaxima,envelopeSkewMinima,envelopeSkewMaxima,stereoLocationMinima,stereoLocationMaxima,interOffsetTimeMinima,interOffsetTimeMaxima,ftableReadLocationIncrement,readIncrementQuanta,interOffsetTimeQuanta] Nothing 2 (Special 0) NoId

-- | Signal shuffler (Linear)
--
--  RShufflerL [AR] in=0.0 fragmentSize=5.0e-3 maxDelay=5.0e-3;    FILTER: TRUE
rShufflerL :: UGen -> UGen -> UGen -> UGen
rShufflerL in_ fragmentSize maxDelay = mkUGen Nothing [AR] (Right [0]) "RShufflerL" [in_,fragmentSize,maxDelay] Nothing 1 (Special 0) NoId

-- | Find buffer index and rate multiplier given table of MNN.
--
--  RSmplrIndex [KR] buf=0.0 size=0.0 mnn=60.0
rSmplrIndex :: Rate -> UGen -> UGen -> UGen -> UGen
rSmplrIndex rate buf size mnn = mkUGen Nothing [KR] (Left rate) "RSmplrIndex" [buf,size,mnn] Nothing 2 (Special 0) NoId

-- | Read trace buffer
--
--  RTraceRd [KR,AR] bufnum=0.0 degree=4.0 index=0.0 access=1.0
rTraceRd :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen
rTraceRd rate bufnum degree index_ access = mkUGen Nothing [KR,AR] (Left rate) "RTraceRd" [bufnum,degree,index_,access] Nothing 1 (Special 0) NoId

-- | Dynamic library host
--
--  RDL [AR] *inputs=0.0;    MCE=1, NC INPUT: True
rdl :: Int -> UGen -> UGen
rdl numChannels inputs = mkUGen Nothing [AR] (Left AR) "RDL" [] (Just [inputs]) numChannels (Special 0) NoId

-- | Multi-channel variant of IRand
--
--  RIRandN [IR] lo=1.0e-4 hi=1.0;    NC INPUT: True, NONDET
riRandN :: ID a => Int -> a -> UGen -> UGen -> UGen
riRandN numChannels z lo hi = mkUGen Nothing [IR] (Left IR) "RIRandN" [lo,hi] Nothing numChannels (Special 0) (toUId z)

-- | Decay bin magnitudes according to multipliers in table.
--
--  RPVDecayTbl [KR] fft_buf=0.0 decay_rate_buf=0.0 history_buf=0.0
rpvDecayTbl :: Rate -> UGen -> UGen -> UGen -> UGen
rpvDecayTbl rate fft_buf decay_rate_buf history_buf = mkUGen Nothing [KR] (Left rate) "RPVDecayTbl" [fft_buf,decay_rate_buf,history_buf] Nothing 1 (Special 0) NoId

-- | Generate new exponentially distributed random values on trigger.
--
--  RTExpRandN [KR] lo=0.0 hi=1.0 trigger=0.0;    NC INPUT: True, FILTER: TRUE, NONDET
rtExpRandN :: ID a => Int -> a -> UGen -> UGen -> UGen -> UGen
rtExpRandN numChannels z lo hi trigger = mkUGen Nothing [KR] (Right [2]) "RTExpRandN" [lo,hi,trigger] Nothing numChannels (Special 0) (toUId z)

-- | Generate new random values on trigger.
--
--  RTRandN [KR] lo=0.0 hi=1.0 trigger=0.0;    NC INPUT: True, FILTER: TRUE, NONDET
rtRandN :: ID a => Int -> a -> UGen -> UGen -> UGen -> UGen
rtRandN numChannels z lo hi trigger = mkUGen Nothing [KR] (Right [2]) "RTRandN" [lo,hi,trigger] Nothing numChannels (Special 0) (toUId z)

-- | Scramble inputs on trigger.
--
--  RTScramble [IR,KR] trigger=0.0 *inputs=0.0;    MCE=1, FILTER: TRUE, NONDET
rtScramble :: ID a => a -> UGen -> UGen -> UGen
rtScramble z trigger inputs = mkUGen Nothing [IR,KR] (Right [0]) "RTScramble" [trigger] (Just [inputs]) (length (mceChannels inputs) + 0) (Special 0) (toUId z)

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
