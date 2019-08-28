module Ui.Basic.Card exposing (attributes)

import Browser
import Color.Manipulate as Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Ui.Basic exposing (..)
import Ui.Color as Color


attributes : List (Attribute msg)
attributes =
    [ Background.color <| Color.uiColor Color.white
    , padding 16
    , Border.rounded 4
    , Border.shadow
        { offset = ( 0, 0 )
        , size = 1
        , blur = 0
        , color = Color.uiColor Color.samuzora
        }
    ]


main : Program () String String
main =
    Browser.sandbox
        { init = "init"
        , view =
            \model ->
                layout ([ padding 64, Background.color <| Color.uiColor Color.basicary ] ++ font) <|
                    column attributes [ text "card", text "test" ]
        , update = \msg _ -> Debug.log "msg" msg
        }
