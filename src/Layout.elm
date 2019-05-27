module Layout exposing
    ( leftPanel
    , midPanel
    , rightPanel
    , toolBar
    )

import Dict exposing (Dict, empty, fromList, get)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (..)
import Element.Font as Font
import Element.Input as Input
import Msg exposing (Msg(..))
import Ntree exposing (Nid, Ntree)


mainColor =
    rgb255 52 101 164


togglePanelButton : Bool -> Bool -> Element Msg
togglePanelButton isLeft isOpen =
    let
        align =
            if isLeft then
                alignLeft

            else
                alignRight
    in
    Input.button
        [ padding 5
        , align
        ]
        { onPress = Just <| ToggleSidePanel isLeft
        , label = text "|||"
        }


toolBar : Element Msg
toolBar =
    row
        [ width fill
        , paddingXY 10 10
        , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
        , Border.color mainColor
        ]
        [ togglePanelButton True True
        , text
            "Tool Bar"
        , togglePanelButton False True
        ]


leftPanel : Int -> Element Msg
leftPanel w =
    column
        [ height fill
        , width (px w)
        , alignLeft
        , Border.widthEach { bottom = 0, top = 0, left = 0, right = 1 }

        --, Background.color <| rgb255 92 99 118
        --, Font.color <| rgb255 255 255 255
        ]
        [ text "Left Panel" ]


midPanel : Element Msg
midPanel =
    column
        [ height fill
        , centerX
        ]
        [ text "Middle Panel" ]


rightPanel : Int -> Element Msg
rightPanel w =
    column
        [ height fill
        , width (px w)
        , alignRight
        , Border.widthEach { bottom = 0, top = 0, left = 1, right = 0 }

        --, Background.color <| rgb255 92 99 118
        --, Font.color <| rgb255 255 255 255
        ]
        [ text "Right Panel" ]
