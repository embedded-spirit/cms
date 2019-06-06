module Ntree exposing
    ( Branch
    , Kind(..)
    , Nid
    , Node
    , Ntree
    , Page
    , decodeNtree
    )

import Dict exposing (Dict, empty, fromList, get, insert, update)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)


type alias Nid =
    String


type alias BranchItem =
    { nid : Nid
    , hidden : Bool
    , link : Bool
    }


type alias Branch =
    List BranchItem



-- Pages


type alias PageSettings =
    { title : String
    }


type alias PageStyle =
    { size : String
    }


type alias Page =
    { title : String

    --, settings : PageSettings
    --, style : PageStyle
    }


type alias Pages =
    { title : String
    }



-- Collection


type alias CollectionStyle =
    { dir : String
    }


type alias Collection =
    { title : String

    --, style : CollectionStyle
    }


type alias ErrNode =
    { description : String
    }


type Kind
    = KindPages Pages
    | KindPage Page
    | KindCollection Collection
    | KindErrNode ErrNode


type alias Node =
    { nid : Nid
    , pid : Maybe Nid
    , kind : Kind

    --, branch : Maybe Branch
    }


type alias Ntree =
    Dict Nid Node


toNpair : List Node -> List ( Nid, Node )
toNpair =
    List.map <| \n -> ( n.nid, n )


errTree : Error -> String
errTree err =
    case err of
        Field name ferr ->
            name

        Index index ierr ->
            "index: " ++ String.fromInt index

        Failure reason reer ->
            reason

        _ ->
            "OneOf"


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
                firstErr =
                    errTree err

                errNode =
                    { nid = "err"
                    , pid = Nothing
                    , kind = KindErrNode (ErrNode "error decoding ntree")

                    --, style = fromList [ ( "size", StrProp "full" ) ]
                    --, branch = Nothing
                    }
            in
            fromList
                [ ( firstErr, errNode ) ]


decodeNode : Decoder Node
decodeNode =
    succeed Node
        |> required "nid" string
        |> required "pid" (nullable string)
        |> required "kind" decodeKind



--|> optional "branch" (map Just <| list decodeBranch) Nothing


decodeKind : Decoder Kind
decodeKind =
    oneOf
        [ map KindPages decodePages
        , map KindPage decodePage
        , map KindCollection decodeCollection
        ]


decodePages : Decoder Pages
decodePages =
    let
        toPages : String -> String -> Decoder Pages
        toPages name title =
            if name == "pages" then
                succeed (Pages title)

            else
                fail "It's not Pages"
    in
    succeed toPages
        |> required "name" string
        |> required "title" string
        |> resolve


decodePage : Decoder Page
decodePage =
    let
        toPage : String -> String -> Decoder Page
        toPage name title =
            if name == "page" then
                succeed (Page title)

            else
                fail "It's not Page"
    in
    succeed toPage
        |> required "name" string
        |> required "title" string
        |> resolve


decodeCollection : Decoder Collection
decodeCollection =
    let
        toCollection : String -> String -> Decoder Collection
        toCollection name title =
            if name == "collection" then
                succeed (Collection title)

            else
                fail "It's not Collection"
    in
    succeed toCollection
        |> required "name" string
        |> required "title" string
        |> resolve


decodeBranch : Decoder BranchItem
decodeBranch =
    succeed BranchItem
        |> required "nid" string
        |> required "hidden" bool
        |> required "link" bool
