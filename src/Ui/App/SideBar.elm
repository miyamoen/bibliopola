module Ui.App.SideBar exposing (view)

import Browser
import Color.Manipulate as Color
import Dict
import Element exposing (..)
import Element.Background as Background
import Element.Events exposing (onClick)
import Element.Font as Font
import Types exposing (..)
import Ui.App.Explorer as Explorer
import Ui.Basic exposing (..)
import Ui.Color as Color
import Url.Builder


view : List (Attribute Msg) -> BoundBook -> Model -> Element Msg
view attrs book model =
    column
        ([ height fill
         , scrollbarY
         , Background.color <| Color.uiColor Color.umoregi
         , Font.color <| Color.uiColor <| Color.lighten 0.3 Color.font
         ]
            ++ attrs
        )
        [ link [ width fill, padding 16, Font.size 32 ]
            { url = Url.Builder.absolute [] []
            , label = text "Bibliopola"
            }
        , Explorer.view [ width fill ] model.route book
        ]
