{-#LANGUAGE ForeignFunctionInterface, OverloadedStrings
, NoMonomorphismRestriction #-}

import Haste.App hiding (get)
import Haste.DOM
import Haste.Prim

import Control.Monad
import Hom.DOM
import Hom.Animate
import Haste.Concurrent
import Control.Monad.Trans.State

a =: b = (a,b)

dom  title =
  node "div" []
    [ node "h1" ["style" =: "color:red;"] [text title] ]


render count =
  node "div" [] [text . toJSStr $ show count]
main :: IO ()
main = concurrent $ do
  ctr <- newEmptyMVar 
  dom <- newMVar . render $ 0
  forkIO $ counter ctr  0
  renderer ctr dom
  return ()

counter :: MVar Int -> Int -> CIO ()
counter ctr startval =
  go startval
  where
      go n = do
      putMVar ctr n
      wait 1000
      go (n+1)

renderer :: MVar Int -> MVar Node -> CIO ()
renderer ctr dom =
    withElem "root"  $ \root -> do
          current <- takeMVar dom
          count <- takeMVar ctr
          let next = render count
          putMVar dom next
          let patches = diff current next
          waitForAnimationFrame
          patch patches root
          renderer ctr dom

-- TODO batch updates