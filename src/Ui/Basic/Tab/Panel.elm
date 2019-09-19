module Ui.Basic.Tab.Panel exposing (attributes)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Html.Attributes
import SelectList exposing (SelectList)
import Ui.Basic exposing (..)
import Ui.Color as Color exposing (white)


attributes : List (Attribute msg)
attributes =
    [ width fill
    , height fill
    , padding 8
    , Background.color <| Color.uiColor Color.shirahanoya
    , Border.color <| Color.uiColor Color.aiirohatoba
    , Border.width 2
    , Border.roundEach
        { topLeft = 0
        , topRight = 4
        , bottomLeft = 0
        , bottomRight = 4
        }
    ]
