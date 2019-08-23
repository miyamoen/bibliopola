module Ui.Basic.Radio exposing (Config, view)

import Color
import Element exposing (..)
import Element.Border as Border
import Html exposing (Html)
import Html.Attributes
import List.Extra as List
import Ui.Color as Color


type alias Config msg =
    { selected : Bool
    , msg : msg
    , label : Element msg
    }


view : List (Element.Attribute msg) -> Config msg -> Element msg
view attrs { selected, msg, label } =
    el [] <|
        row
            ([ spacing 8
             , htmlAttribute <| Html.Attributes.tabindex 1
             ]
                ++ attrs
            )
            [ text "選ぶやつ", label ]


main : Html String
main =
    layout [ padding 64 ] <|
        column []
            [ view []
                { selected = True
                , msg = "first"
                , label = text "first"
                }
            , view []
                { selected = False
                , msg = "second"
                , label = text "second"
                }
            ]
