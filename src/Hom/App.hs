{-# LANGUAGE ForeignFunctionInterface #-}

module Hom.App 
(
  app
)
where

import Hom.DOM
import Haste.DOM
import Haste.Concurrent
import Haste.Prim
import Hom.Animate
import Control.Monad.IO.Class


app initialState render root update = concurrent . withElem root $ \rootEl -> do
  stateMVar <- newEmptyMVar
  let currentDOM = render initialState
  forkIO $ update initialState stateMVar
  let go = do
        state <- takeMVar stateMVar
        let nextDOM = render state
        let patches = diff currentDOM  nextDOM
        patch patches rootEl
        go
  go