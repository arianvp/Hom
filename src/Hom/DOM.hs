module DOM 
( diff
, patch
, node
, text
)
where

import Haste.DOM

newtype Patches = Patches JSAny
newtype Node = Node JSAny

instance Pack Patches
instance Unpack Patches
instance Pack Node
instance Unpack Node

node :: String -> [Attr] -> Node
text :: String -> Node

diff :: Node -> Node -> Patches
diff = ffi "function (node) { return require('virtual-dom/diff')(node) }"


patch :: MonadIO m => Patches -> Elem -> m () 
patch = ffi "function (patches, elem) { require('virtual-dom/patch')(elem,patches) }" 
