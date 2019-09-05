module Ui.Basic.Button exposing (Config, view)

import Color
import Color.Manipulate as Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Ui.Basic exposing (..)
import Ui.Color as Color exposing (white)


type alias Config msg =
    { color : Color.Color
    , msg : msg
    , label : Element msg
    , disabled : Bool
    }


view : List (Attribute msg) -> Config msg -> Element msg
view attrs { color, msg, label, disabled } =
    el attrs <|
        row
            ([ width fill
             , height fill
             , paddingXY 32 16
             , tabindex
             , focusedStyle
             , Font.color <| Color.uiColor white
             , pointer
             ]
                ++ (if disabled then
                        [ Background.color <| Color.uiColor <| Color.fadeOut 0.4 color ]

                    else
                        [ onEnter msg
                        , onClick msg
                        , Background.color <| Color.uiColor color
                        , pointer
                        ]
                   )
            )
            [ label ]
