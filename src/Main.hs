{-# LANGUAGE OverloadedStrings #-}

import Haste.Prim
import Haste.Concurrent
import Hom.DOM
import Hom.App

count  :: Int -> Node
count c = node "div" ["style"=:"color:red;"] [ text . toJSStr . show $ c]

counter startval ctr =
  go startval
  where
    go n = do
      putMVar ctr n
      wait 1000
      go $ n+1

main = app 0 count "root" counter