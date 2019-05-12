module Ntree exposing
    ( Branch
    , Dir(..)
    , Element(..)
    , Image
    , Label
    , Nid
    , Node
    , Ntree
    , StackView
    , addWidget
    , initialTree
    , vstack
    )

import Dict exposing (Dict, empty, fromList, get, insert, update)


type alias Nid =
    String


type alias Branch =
    List Nid


type Dir
    = V
    | H


type alias StackView =
    { dir : Dir
    , fill : String
    }


type alias Label =
    { text : String
    , fontFamily : String
    , fontSize : Int
    }


type alias Image =
    { url : String
    , width : Float
    , height : Float
    }


type Element
    = StackViewWidget StackView
    | LabelWidget Label
    | ImageWidget Image
    | WidgetSelector


type alias Node =
    { nid : Nid
    , pid : Nid
    , element : Element
    , branch : Branch
    }


type alias Ntree =
    Dict Nid Node


vstack : ( Nid, Nid ) -> Node
vstack ( nid, pid ) =
    { nid = nid
    , pid = pid
    , element = StackViewWidget { dir = V, fill = "-" }
    , branch = []
    }


initialTree : Dict String Node
initialTree =
    fromList [ ( "root", vstack ( "root", "root" ) ) ]


addWidget : Nid -> Ntree -> Ntree
addWidget nid ntree =
    let
        hostNode =
            get nid ntree
    in
    case hostNode of
        Just host ->
            let
                sid =
                    "select-widget"

                widgetSelector =
                    { nid = sid
                    , pid = nid
                    , element = WidgetSelector
                    , branch = []
                    }

                host2 =
                    { host | branch = host.branch ++ [ sid ] }

                updateNtree =
                    insert sid widgetSelector << update host.nid (Maybe.map (always host2))
            in
            updateNtree ntree

        Nothing ->
            ntree
