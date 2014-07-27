{-#LANGUAGE ForeignFunctionInterface, OverloadedStrings #-}
import Hom.DOM
import Haste.DOM
import Haste.Prim

a =: b = (a,b)

dom  title =
  node "div" ["class" =: "red"]
    [ node "h1" [] [text title] ]


main = withElem "root" $ \root -> do
  let current = dom "hello"
  el <- createElement current
  addChild el root
  let patches = diff current (dom "halddlo")
  patch patches el

