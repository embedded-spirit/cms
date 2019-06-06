module Main exposing (main)

import Browser
import Dict exposing (Dict, empty, fromList, get)
import Element exposing (..)
import Html
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (..)
import Layout exposing (..)
import Msg exposing (Msg(..))
import Ntree exposing (..)
import Widgets.Collection exposing (..)



---- MODEL ----


type alias Flags =
    { ntree : String
    , seed : Int
    }


type SidePanel
    = SidePanel Bool Int


type alias Model =
    { currentSeed : Int
    , leftPanel : SidePanel
    , rightPanel : SidePanel
    , ntree : Ntree
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        ntree =
            decodeNtree flags.ntree
    in
    ( { currentSeed = flags.seed
      , leftPanel = SidePanel True 300
      , rightPanel = SidePanel True 300
      , ntree = ntree
      }
    , Cmd.none
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleSidePanel isLeft ->
            let
                model2 =
                    if isLeft then
                        case model.leftPanel of
                            SidePanel True w ->
                                { model | leftPanel = SidePanel False w }

                            SidePanel False w ->
                                { model | leftPanel = SidePanel True w }

                    else
                        case model.rightPanel of
                            SidePanel True w ->
                                { model | rightPanel = SidePanel False w }

                            SidePanel False w ->
                                { model | rightPanel = SidePanel True w }
            in
            ( model2, Cmd.none )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "Native CMS"
    , body =
        [ layout [] <|
            let
                leftP =
                    case model.leftPanel of
                        SidePanel True w ->
                            [ leftPanel w model.ntree ]

                        SidePanel False _ ->
                            []

                rightP =
                    case model.rightPanel of
                        SidePanel True w ->
                            [ rightPanel w model.ntree ]

                        SidePanel False _ ->
                            []

                midP =
                    [ midPanel model.ntree ]
            in
            column [ width fill, height fill ]
                [ toolBar
                , row [ height fill, width fill ] <| leftP ++ midP ++ rightP
                ]
        ]
    }



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.document
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
