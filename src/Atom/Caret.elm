module Atom.Caret exposing (Config, Direction(..), directions, view)

import Color.Pallet as Pallet exposing (Pallet(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Util exposing (maybeOnClick)
import Svg exposing (..)
import Svg.Attributes exposing (points, viewBox)
import Types exposing (..)


type Direction
    = Up
    | Down
    | Right
    | Left


directions : List Direction
directions =
    [ Up, Down, Right, Left ]


type alias Config a msg =
    { a
        | pallet : Pallet
        , onClick : Maybe (Direction -> msg)
        , size : Float
    }


view : Config a msg -> Direction -> Element (Styles s) (Variation v) msg
view { pallet, onClick, size } direction =
    el None
        [ inlineStyle
            [ "fill" => Pallet.css pallet
            , "transform" => rotateCss direction
            , "transition-property" => "transform"
            , "transition-duration" => "0.2s"
            , "cursor"
                => (Maybe.map (always "pointer") onClick
                        |> Maybe.withDefault ""
                   )
            ]
        , width <| px size
        , height <| px size
        , maybeOnClick <| Maybe.map (\f -> f direction) onClick
        ]
    <|
        Element.html <|
            svg [ viewBox "0 0 512 512" ]
                [ g []
                    [ polygon
                        [ points pointsString ]
                        []
                    ]
                ]


rotateCss : Direction -> String
rotateCss direction =
    String.concat
        [ "rotate("
        , toString <|
            case direction of
                Up ->
                    0

                Down ->
                    180

                Right ->
                    90

                Left ->
                    -90
        , "deg)"
        ]


pointsString : String
pointsString =
    "255.992,92.089 0,348.081 71.821,419.911 255.992,235.74 440.18,419.911 512,348.081"
