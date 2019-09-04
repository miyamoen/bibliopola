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


view : BoundBook -> Element Msg
view book =
    column
        [ width <| px 200
        , height fill
        , scrollbarY
        , spacing 32
        , Background.color <| Color.uiColor Color.hukurasuzume
        , Font.color <| Color.uiColor <| Color.lighten 0.5 Color.font
        ]
        [ link []
            { url = Url.Builder.absolute [] []
            , label = text "Bibliopola"
            }
        , Explorer.view [] book
        ]
