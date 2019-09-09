module Ui.Basic.Card exposing (attributes, headerAttributes)

import Browser
import Color.Manipulate as Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Ui.Basic exposing (..)
import Ui.Color as Color


attributes : List (Attribute msg)
attributes =
    [ Background.color <| Color.uiColor Color.white
    , Border.rounded 2
    , Border.shadow
        { offset = ( 0, 0 )
        , size = 1
        , blur = 0
        , color = Color.uiColor Color.hinemos
        }
    ]


headerAttributes : List (Attribute msg)
headerAttributes =
    [ Background.color <| Color.uiColor Color.hinemos
    , Font.color <| Color.uiColor Color.white
    ]
