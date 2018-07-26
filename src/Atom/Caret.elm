module Caret exposing (..)

import Bibliopola exposing (..)
import Color.Pallet as Pallet exposing (Pallet(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events as Events
import Styles exposing (styles)
import Svg exposing (..)
import Svg.Attributes exposing (points, viewBox)
import Types exposing (..)


type Direction
    = Up
    | Down
    | Right
    | Left


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
            , "transition-duration" => "0.5s"
            , "cursor" => "pointer"
            ]
        , width <| px size
        , height <| px size
        , case onClick of
            Just f ->
                Events.onClick <| f direction

            Nothing ->
                classList []
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


viewItem : View (Styles s) (Variation v)
viewItem =
    let
        config pallet =
            { pallet = pallet
            , onClick = Just (\dir -> toString dir ++ " clicked!")
            , size = 256
            }
    in
    createViewItem2 "Caret"
        view
        ( "pallet"
        , List.map (\p -> toString p => config p) Pallet.pallets
        )
        ( "direction"
        , [ "Up" => Up
          , "Down" => Down
          , "Right" => Right
          , "Left" => Left
          ]
        )
        |> withDefaultVariation (view (config Black) Up)


main : MyProgram (Styles s) (Variation v)
main =
    createMainFromViewItem styles viewItem
