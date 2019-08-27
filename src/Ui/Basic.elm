module Ui.Basic exposing (focusedStyle, font)

import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Ui.Color as Color


focusedStyle : Attribute msg
focusedStyle =
    focused
        [ Border.shadow
            { offset = ( 0, 0 )
            , size = 2
            , blur = 1
            , color = Color.uiColor Color.secondary
            }
        ]


font : List (Attribute msg)
font =
    [ Font.family
        [ Font.external
            { url = "https://fonts.googleapis.com/css?family=Barlow+Semi+Condensed&display=swap"
            , name = "Barlow Semi Condensed"
            }
        , Font.sansSerif
        ]
    ]
