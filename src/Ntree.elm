module Ntree exposing
    ( Branch
    , Nid
    , Node
    , Ntree
    , Prop(..)
    , Props
    )

import Dict exposing (Dict, empty, fromList, get, insert, update)


type alias Nid =
    String


type alias Branch =
    List Nid


type Prop
    = StrProp String
    | IntProp Int
    | BoolProp Bool


type alias Props =
    Dict String Prop


type alias Node =
    { nid : Nid
    , pid : Maybe Nid
    , name : String
    , settings : Props
    , style : Props
    , branch : Maybe Branch
    }


type alias Ntree =
    Dict Nid Node
