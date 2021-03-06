{-#LANGUAGE ForeignFunctionInterface, GeneralizedNewtypeDeriving #-}
module Hom.DOM 
( createElement
, diff
, patch
, text
, node
, Node
, Elem
, (=:)
)
where

import Haste.DOM
import Haste.Foreign
import Haste.App
import Haste.Serialize
import Haste.JSON
import Haste.Prim


a =: b = (a,b)
newtype Patches = Patches JSAny deriving (Pack, Unpack)
newtype Node = Node JSAny deriving (Pack, Unpack)
newtype Nodes = Nodes JSAny deriving (Pack, Unpack)
newtype Properties = Properties JSAny deriving (Pack, Unpack)
newtype Children = Children JSAny deriving (Pack, Unpack)

foreign import ccall "jsEmpty"  jsNodesEmpty   :: Nodes
foreign import ccall "jsConcat" jsNodesConcat  :: Nodes -> Nodes -> Nodes
foreign import ccall "jsCons"   jsNodesCons    :: Node  -> Nodes -> Nodes


foreign import ccall jsCreateElement :: Node -> IO Elem
foreign import ccall jsDiff :: Node -> Node -> Patches
foreign import ccall jsPatch ::  Patches -> Elem -> IO () 
foreign import ccall jsText :: JSString -> Node 
foreign import ccall jsNode :: JSString -> Properties -> Nodes -> Node
foreign import ccall lst2arr :: Ptr ([Node]) -> Nodes

createElement :: MonadIO m => Node -> m Elem
createElement n = liftIO $ jsCreateElement n

diff :: Node -> Node -> Patches
diff = jsDiff

patch :: MonadIO m => Patches -> Elem -> m ()
patch p e= liftIO $ jsPatch p e

text :: JSString -> Node
text = jsText


toNodes :: [Node] -> Nodes
toNodes = foldr jsNodesCons jsNodesEmpty



node ::  JSString -> [(JSString, JSString)] -> [Node] -> Node
node selector properties children = jsNode selector (Properties $ properties') (toNodes children)
  where properties' = toObject . Dict $ map (\(a,b)->(a, Str b)) properties
--node name attrs children = let attrs' = toJSON: . toObject $ attrs 