module Ui.Basic exposing (focusedStyle)

import Element exposing (..)
import Element.Border as Border
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
