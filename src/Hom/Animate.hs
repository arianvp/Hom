{-# LANGUAGE ForeignFunctionInterface #-}
module Hom.Animate
( requestAnimationFrame
, waitForAnimationFrame
)
where

import Control.Monad.IO.Class
import Haste.Prim
import Haste.Concurrent

newtype JSFun a = JSFun (Ptr a)

foreign import ccall jsRaf :: JSFun a -> IO ()

mkCallback :: a -> JSFun a
mkCallback = JSFun . toPtr


requestAnimationFrame :: MonadIO m => IO () -> m ()
requestAnimationFrame cb = liftIO $ jsRaf (mkCallback $! cb)

requestAnimationFrame' :: MonadIO m => CIO () -> m ()
requestAnimationFrame' cb =
  liftIO $ jsRaf (mkCallback $! concurrent cb)


waitForAnimationFrame :: CIO ()
waitForAnimationFrame = do
  v <- newEmptyMVar
  liftIO $ requestAnimationFrame' $ putMVar v ()
  takeMVar v

