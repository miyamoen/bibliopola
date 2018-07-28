module View exposing (..)

import Element exposing (..)
import Html exposing (Html)
import Page.Main
import Styles exposing (styleSheet)
import Types exposing (..)


view : Model child childVar -> Html (Msg child childVar)
view model =
    viewport (styleSheet model.styles) <|
        Page.Main.view model
