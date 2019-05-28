module Ntree exposing
    ( Branch
    , Nid
    , Node
    , Ntree
    , Prop(..)
    , Props
    , decodeNtree
    )

import Dict exposing (Dict, empty, fromList, get, insert, update)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)


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


toNpair : List Node -> List ( Nid, Node )
toNpair =
    List.map <| \n -> ( n.nid, n )


decodeNtree : String -> Ntree
decodeNtree json =
    let
        dec =
            map fromList <| map toNpair <| list decodeNode
    in
    case decodeString dec json of
        Ok res ->
            res

        Err err ->
            let
                errNode =
                    { nid = "1"
                    , pid = Nothing
                    , name = "error"
                    , settings =
                        fromList [ ( "name", StrProp "error1" ) ]
                    , style = fromList [ ( "size", StrProp "full" ) ]
                    , branch = Nothing
                    }
            in
            fromList
                [ ( "1", errNode ) ]


decodeNode : Decoder Node
decodeNode =
    succeed Node
        |> required "nid" string
        |> required "pid" (nullable string)
        |> required "name" string
        |> required "seetings" (dict decodeProp)
        |> required "style" (dict decodeProp)
        |> optional "branch" (map Just <| list string) Nothing


decodeProp : Decoder Prop
decodeProp =
    oneOf
        [ map StrProp string
        , map IntProp int
        , map BoolProp bool
        ]
