module Widgets.Collection exposing (collection)

import Dict exposing (Dict, empty, fromList, get)
import Ntree exposing (..)


collection : Nid -> Bool -> Node
collection nid isVertical =
    { nid = nid
    , pid = Nothing
    , name = "Collection"
    , settings = fromList [ ( "title", StrProp "" ) ]
    , style = fromList [ ( "isVertical", BoolProp isVertical ) ]
    , branch = Nothing
    }
