module Layout exposing
    ( addWidgetButton
    , showLayoutElement
    )

import Dict exposing (Dict, empty, fromList, get)
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Ntree exposing (Element(..), Nid, Ntree)


addWidgetButton : Nid -> Html Msg
addWidgetButton nid =
    div
        [ class "add-widget"
        , onClick (AddWidget nid)
        ]
        [ text "(+)" ]


showLayoutElement : Ntree -> Nid -> Html Msg
showLayoutElement ntree nid =
    let
        x =
            get nid ntree
    in
    case x of
        Just node ->
            let
                log =
                    Debug.log "showLayoutElement: " (Debug.toString node.branch)
            in
            case node.element of
                StackViewWidget stackview ->
                    div
                        [ class "v-stack" ]
                        (List.map
                            (showLayoutElement ntree)
                            node.branch
                            ++ [ addWidgetButton node.nid ]
                            ++ [ text log ]
                        )

                WidgetSelector ->
                    div [ class "select-widget" ]
                        [ text "SELECT WIDGET" ]

                _ ->
                    text "Error: element?"

        Nothing ->
            text "Error: cannot find root node"
