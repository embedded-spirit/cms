module Main exposing (main)

import Browser
import Dict exposing (Dict, empty, fromList, get)
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Layout exposing (showLayoutElement)
import Msg exposing (Msg(..))
import Ntree exposing (Branch, Dir(..), Element(..), Nid, Node, Ntree, addWidget, initialTree)
import Random exposing (Seed, generate, initialSeed, int, step)



--type Seed = Seed Int Int
--type Generator a = Generator (Seed -> (a, Seed))
---- MODEL ----


type alias Model =
    { currentSeed : Seed
    , ntree : Ntree
    }


toNid : Int -> Nid
toNid =
    (++) "a" << String.fromInt


getNid : Seed -> ( Nid, Seed )
getNid =
    Tuple.mapFirst toNid << step (int 1 1000)


init : Int -> ( Model, Cmd Msg )
init digit =
    let
        seed =
            initialSeed digit

        --( nid, newseed ) = getNid seed
    in
    ( { currentSeed = seed
      , ntree = initialTree
      }
    , Cmd.none
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddWidget nid ->
            ( { model | ntree = addWidget nid model.ntree }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "editor" ]
        [ div [ class "top-left" ] [ text "top-left" ]
        , div [ class "top-mid" ] [ text "top-mid" ]
        , div [ class "top-right" ] [ text "top-right" ]
        , div [ class "left-top-tool" ] [ text "left-top-tool" ]
        , div [ class "left-mid-tool" ] [ text "left-mid-tool" ]
        , div [ class "left-bottom-tool" ] [ text "left-bottom-tool" ]
        , div [ class "device-header" ] [ text "device-header" ]
        , div [ class "device-page" ]
            [ text "device-page"
            ]
        , div [ class "layout-header" ] [ text "layout-header" ]
        , div [ class "layout-page" ] [ showLayoutElement model.ntree "root" ]
        , div [ class "right-top-tool" ]
            [ div [ class "tools-section-stacks" ]
                [ div [ class "v-stack" ] [ text "V-Stack" ]
                , div [ class "h-stack" ] [ text "H-Stack" ]
                ]
            ]
        , div [ class "right-mid-tool" ] [ text "right-mid-tool" ]
        , div [ class "right-bottom-tool" ] [ text "righht-bottom-tool" ]
        ]



---- PROGRAM ----


main : Program Int Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
