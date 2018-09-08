module Atom.Icon exposing (Config, view)

import Element exposing (..)
import Element.Util exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (d, viewBox)


type alias Config a msg =
    { a
        | color : Color
        , onClick : Maybe msg
        , size : Int
    }


view : List (Svg msg) -> Config a msg -> Element msg
view svgDoms { onClick, size, color } =
    el
        [ width <| px size
        , height <| px size
        , svgColor color
        , attributeWhenJust onClick (always pointer)
        , onClickWhenJust onClick
        ]
    <|
        Element.html <|
            svg [ viewBox "0 0 512 512" ] svgDoms
