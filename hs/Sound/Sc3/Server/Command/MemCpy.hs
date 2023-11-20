{- | MemCpy -}
module Sound.Sc3.Server.Command.MemCpy where

import Control.Monad {- base -}
import System.Environment {- base -}

import qualified Data.ByteString.Lazy as ByteString.Lazy {- bytestring -}
import qualified Data.Vector.Storable as Vector {- vector -}

import qualified Sound.Osc.Core as Osc {- hosc -}
import qualified Sound.Sc3 as Sc3 {- hsc3 -}

import qualified Sound.File.Vector as Vector {- hsc3-sf -}

import qualified Sound.File.HSndFile as Sf {- hsc3-sf-hsndfile -}

{- | b_gen memcpy is in sc3-rdu (implemented at BufMemCpy).
Note that BufMemCpy has a flag to indicate whether data is in network order.
Since no BigEndian machines run Sc send in LittleEndian order.
-}
b_memcpy :: Sc3.Buffer_Id -> Int -> Int -> Double -> Osc.Blob -> Int -> Osc.Message
b_memcpy bufferNumber numFrames numChannels sampleRate bufferData byteSwap =
  Sc3.b_gen
  bufferNumber
  "memcpy"
  [Osc.int32 numFrames
  ,Osc.int32 numChannels
  ,Osc.float sampleRate
  ,Osc.Blob bufferData
  ,Osc.int32 byteSwap]

{- | Allocate buffer space and send a locally read sound file.
Arguments are as for b_allocRead,
including that a frameCount of zero indicates the complete file.
-}
b_allocSend :: Sc3.Buffer_Id -> String -> Sc3.Buffer_Ix -> Sc3.Buffer_Ix -> IO Osc.Message
b_allocSend bufferNumber fileName startFrame frameCount = do
  (hdr,dat) <- Sf.read_vec_f32 fileName
  let frameCount' =
        if frameCount <= 0
        then Sf.frameCount hdr - startFrame
        else min frameCount (Sf.frameCount hdr - startFrame)
      dat' = Vector.take (frameCount' * Sf.channelCount hdr) (Vector.drop (startFrame * Sf.channelCount hdr) dat)
  bytes <- Sf.vec_f32_bytestring dat'
  return
    (Sc3.withCm
     (Sc3.b_alloc
       bufferNumber
       frameCount'
       (Sf.channelCount hdr))
      (b_memcpy
       bufferNumber
        frameCount'
        (Sf.channelCount hdr)
        (Sf.sampleRate hdr)
        (ByteString.Lazy.fromStrict bytes)
        0))

-- | Allocate buffer space and send a locally read sound file.
b_allocSendChannel :: Sc3.Buffer_Id -> String -> Sc3.Buffer_Ix -> Sc3.Buffer_Ix -> [Int] -> IO Osc.Message
b_allocSendChannel bufferNumber fileName startFrame frameCount channels = do
  (hdr,dat) <- Sf.read_vec_f32 fileName
  print ("b_allocSendChannel", hdr)
  let datCh = Vector.vec_deinterleave (Sf.channelCount hdr) dat
  when (maximum channels >= Sf.channelCount hdr) (error "b_allocSendChannel: channels out of range")
  let frameCount' =
        if frameCount <= 0
        then Sf.frameCount hdr - startFrame
        else min frameCount (Sf.frameCount hdr - startFrame)
      dat' = Vector.vec_interleave (map (datCh !!) channels)
      dat'' = Vector.take (frameCount' * Sf.channelCount hdr) (Vector.drop (startFrame * Sf.channelCount hdr) dat')
  bytes <- Sf.vec_f32_bytestring dat''
  return
    (Sc3.withCm
      (Sc3.b_alloc
        bufferNumber
        frameCount'
        (Sf.channelCount hdr))
      (b_memcpy
        bufferNumber
        frameCount'
        (Sf.channelCount hdr)
        (Sf.sampleRate hdr)
        (ByteString.Lazy.fromStrict bytes)
        0))

-- | If ScIsRemote then load locally and send, else load directly at server.
b_allocReadOrSend :: Sc3.Buffer_Id -> String -> Sc3.Buffer_Ix -> Sc3.Buffer_Ix -> IO Osc.Message
b_allocReadOrSend b p f n = do
  isRemote <- lookupEnv "ScIsRemote"
  if isRemote == Nothing || isRemote == Just "False"
    then return (Sc3.b_allocRead b p f n)
    else b_allocSend b p f n

-- | If ScIsRemote then load locally and send, else load directly at server.
b_allocReadOrSendChannel :: Sc3.Buffer_Id -> String -> Sc3.Buffer_Ix -> Sc3.Buffer_Ix -> [Int] -> IO Osc.Message
b_allocReadOrSendChannel b p f n ch = do
  isRemote <- lookupEnv "ScIsRemote"
  if isRemote == Nothing || isRemote == Just "False"
    then return (Sc3.b_allocReadChannel b p f n ch)
    else b_allocSendChannel b p f n ch
