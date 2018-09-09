module Atom.Icon.Caret exposing
    ( Config
    , Direction(..)
    , directionToString
    , directions
    , view
    )

import Atom.Constant exposing (iconSize)
import Color
import Element exposing (..)
import Element.Util exposing (..)
import Svg exposing (polygon, svg)
import Svg.Attributes exposing (points, viewBox)
import Types exposing (..)


type Direction
    = Up
    | Down
    | Right
    | Left


directionToString : Direction -> String
directionToString direction =
    case direction of
        Up ->
            "up"

        Down ->
            "down"

        Right ->
            "right"

        Left ->
            "left"


directions : List ( String, Direction )
directions =
    List.map (\dir -> Tuple.pair (directionToString dir) dir)
        [ Up
        , Down
        , Right
        , Left
        ]


type alias Config a msg =
    { a
        | color : Color
        , onClick : Maybe (Direction -> msg)
        , size : Int
    }


view : Config a msg -> Direction -> Element msg
view { color, onClick, size } direction =
    el
        [ width <| px <| iconSize size
        , height <| px <| iconSize size
        , svgColor color
        , style "transition-property" "transform"
        , style "transition-duration" "0.2s"
        , rotate <| directionAngle direction
        , attributeWhenJust onClick (always pointer)
        , attributeWhenJust onClick (always pointer)
        , onClickWhenJust <| Maybe.map (\f -> f direction) onClick
        ]
    <|
        Element.html <|
            svg [ viewBox "0 0 512 512" ]
                [ polygon [ points pointsString ] [] ]


directionAngle : Direction -> Float
directionAngle direction =
    degrees <|
        case direction of
            Up ->
                0

            Down ->
                180

            Right ->
                90

            Left ->
                -90


pointsString : String
pointsString =
    "255.992,92.089 0,348.081 71.821,419.911 255.992,235.74 440.18,419.911 512,348.081"
