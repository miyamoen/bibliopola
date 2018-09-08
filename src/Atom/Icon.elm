module Atom.Icon exposing (Config, view)

import Atom.Constant exposing (iconSize)
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
        [ width <| px <| iconSize size
        , height <| px <| iconSize size
        , svgColor color
        , attributeWhenJust onClick (always pointer)
        , onClickWhenJust onClick
        ]
    <|
        Element.html <|
            svg [ viewBox "0 0 512 512" ] svgDoms
