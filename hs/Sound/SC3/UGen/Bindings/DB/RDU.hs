-- | Bindings (AUTOGEN), see "Sound.SC3.UGen.External.RDU"
module Sound.SC3.UGen.Bindings.DB.RDU where

import Sound.SC3.Common.Rate
import Sound.SC3.Common.UId
import Sound.SC3.UGen.Type
import Sound.SC3.UGen.UGen

import Sound.SC3.UGen.Analysis
import Sound.SC3.UGen.Bindings.DB

-- | Range variant of Dust
--
--  DustR [AR] lo=1.0e-4 hi=1.0;    NONDET
dustR :: ID a => a -> Rate -> UGen -> UGen -> UGen
dustR z rate lo hi = mkUGen Nothing [AR] (Left rate) "DustR" [lo,hi] Nothing 1 (Special 0) (toUId z)

-- | Multi-channel variant of Rand
--
--  ExpRandN [IR] lo=1.0e-4 hi=1.0;    NC INPUT: True, NONDET
expRandN :: ID a => Int -> a -> UGen -> UGen -> UGen
expRandN numChannels z lo hi = mkUGen Nothing [IR] (Left IR) "ExpRandN" [lo,hi] Nothing numChannels (Special 0) (toUId z)

-- | Multi-channel variant of IRand
--
--  IRandN [IR] lo=1.0e-4 hi=1.0;    NC INPUT: True, NONDET
iRandN :: ID a => Int -> a -> UGen -> UGen -> UGen
iRandN numChannels z lo hi = mkUGen Nothing [IR] (Left IR) "IRandN" [lo,hi] Nothing numChannels (Special 0) (toUId z)

-- | Multi-channel variant of LinRand
--
--  LinRandN [IR] lo=1.0e-4 hi=1.0 minmax=0.0;    NC INPUT: True, NONDET
linRandN :: ID a => Int -> a -> UGen -> UGen -> UGen -> UGen
linRandN numChannels z lo hi minmax = mkUGen Nothing [IR] (Left IR) "LinRandN" [lo,hi,minmax] Nothing numChannels (Special 0) (toUId z)

-- | Copies spectral frame (ie. PV_Copy with two outputs).
--
--  PV_Split [KR] bufferA=0.0 bufferB=0.0
pv_Split :: UGen -> UGen -> UGen
pv_Split bufferA bufferB = mkUGen Nothing [KR] (Left KR) "PV_Split" [bufferA,bufferB] Nothing 2 (Special 0) NoId

-- | Multi-channel variant of Rand
--
--  RandN [IR] lo=1.0e-4 hi=1.0;    NC INPUT: True, NONDET
randN :: ID a => Int -> a -> UGen -> UGen -> UGen
randN numChannels z lo hi = mkUGen Nothing [IR] (Left IR) "RandN" [lo,hi] Nothing numChannels (Special 0) (toUId z)

-- | Bezier curve oscillator.
--
--  RBezier [KR,AR] freq=440.0 phase=0.0 *param=0.0;    MCE=1
rBezier :: Rate -> UGen -> UGen -> UGen -> UGen
rBezier rate freq phase param = mkUGen Nothing [KR,AR] (Left rate) "RBezier" [freq,phase] (Just [param]) 1 (Special 0) NoId

-- | Network of delay line maps
--
--  RDelayMap [AR] bufnum=0.0 input=0.0 dynamic=0.0 *mapArray=0.0;    MCE=1, FILTER: TRUE
rDelayMap :: UGen -> UGen -> UGen -> UGen -> UGen
rDelayMap bufnum input dynamic mapArray = mkUGen Nothing [AR] (Right [1]) "RDelayMap" [bufnum,input,dynamic] (Just [mapArray]) 1 (Special 0) NoId

-- | Delay set (RTAlloc)
--
--  RDelaySet [AR] input=0.0 *setArray=0.0;    MCE=1, FILTER: TRUE
rDelaySet :: UGen -> UGen -> UGen
rDelaySet input setArray = mkUGen Nothing [AR] (Right [0]) "RDelaySet" [input] (Just [setArray]) 1 (Special 0) NoId

-- | Delay set (Buffer)
--
--  RDelaySetB [AR] buffer=0.0 input=0.0 *setArray=0.0;    MCE=1, FILTER: TRUE
rDelaySetB :: UGen -> UGen -> UGen -> UGen
rDelaySetB buffer input setArray = mkUGen Nothing [AR] (Right [1]) "RDelaySetB" [buffer,input] (Just [setArray]) 1 (Special 0) NoId

-- | Dynamic library host
--
--  RDL [AR] *inputs=0.0;    MCE=1, NC INPUT: True
rdl :: Int -> UGen -> UGen
rdl numChannels inputs = mkUGen Nothing [AR] (Left AR) "RDL" [] (Just [inputs]) numChannels (Special 0) NoId

-- | Concurrent loops at signal buffer
--
--  RFreezer [AR] bufnum=0.0 left=0.0 right=1.0 gain=0.1 increment=1.0 incrementOffset=0.0 incrementRandom=5.0e-2 rightRandom=5.0e-2 syncPhaseTrigger=0.0 randomizePhaseTrigger=0.0 numberOfLoops=6.0
rFreezer :: UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen -> UGen
rFreezer bufnum left right gain increment incrementOffset incrementRandom rightRandom syncPhaseTrigger randomizePhaseTrigger numberOfLoops = mkUGen Nothing [AR] (Left AR) "RFreezer" [bufnum,left,right,gain,increment,incrementOffset,incrementRandom,rightRandom,syncPhaseTrigger,randomizePhaseTrigger,numberOfLoops] Nothing 1 (Special 0) NoId

-- | Play trace buffer
--
--  RPlayTrace [KR,AR] bufnum=0.0 degree=4.0 rate=0.0 access=1.0
rPlayTrace :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen
rPlayTrace rate bufnum degree rate_ access = mkUGen Nothing [KR,AR] (Left rate) "RPlayTrace" [bufnum,degree,rate_,access] Nothing 1 (Special 0) NoId

-- | Decay bin magnitudes according to multipliers in table.
--
--  RPVDecayTbl [KR] fft_buf=0.0 decay_rate_buf=0.0 history_buf=0.0
rpvDecayTbl :: Rate -> UGen -> UGen -> UGen -> UGen
rpvDecayTbl rate fft_buf decay_rate_buf history_buf = mkUGen Nothing [KR] (Left rate) "RPVDecayTbl" [fft_buf,decay_rate_buf,history_buf] Nothing 1 (Special 0) NoId

-- | Generate new random values on trigger.
--
--  TRandN [KR] lo=0.0 hi=1.0 trigger=0.0;    NC INPUT: True, FILTER: TRUE, NONDET
tRandN :: ID a => Int -> a -> UGen -> UGen -> UGen -> UGen
tRandN numChannels z lo hi trigger = mkUGen Nothing [KR] (Right [2]) "TRandN" [lo,hi,trigger] Nothing numChannels (Special 0) (toUId z)

-- | Scramble inputs on trigger.
--
--  TScramble [IR,KR] trigger=0.0 *inputs=0.0;    MCE=1, FILTER: TRUE, NONDET
tScramble :: ID a => a -> UGen -> UGen -> UGen
tScramble z trigger inputs = mkUGen Nothing [IR,KR] (Right [0]) "TScramble" [trigger] (Just [inputs]) (length (mceChannels inputs) + 0) (Special 0) (toUId z)

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

-- | Read trace buffer
--
--  RTraceRd [KR,AR] bufnum=0.0 degree=4.0 index=0.0 access=1.0
rTraceRd :: Rate -> UGen -> UGen -> UGen -> UGen -> UGen
rTraceRd rate bufnum degree index_ access = mkUGen Nothing [KR,AR] (Left rate) "RTraceRd" [bufnum,degree,index_,access] Nothing 1 (Special 0) NoId

-- * Variants

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
