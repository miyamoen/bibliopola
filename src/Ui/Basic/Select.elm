module Ui.Basic.Select exposing (Config, view)

import Element exposing (..)
import Element.Border as Border
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import List.Extra as List
import SelectList
import Ui.Color as Color


type alias Config data msg =
    { data : List data
    , toString : data -> String
    , selected : Maybe Int
    , notSelectedLabel : String
    , msg : Maybe Int -> msg
    }


view : List (Element.Attribute msg) -> Config data msg -> Element msg
view attrs { data, selected, msg, toString, notSelectedLabel } =
    let
        strData =
            List.map toString data
    in
    select
        [ onInput (\str -> List.findIndex ((==) str) strData |> msg)
        , style "-webkit-appearance" "none"
        , style "-moz-appearance" "none"
        , style "appearance" "none"
        , style "padding" "0.5em 1em"
        , style "border-radius" "4px"
        , style "border-color" <| Color.toCss Color.primary
        , style "border-width" "4px"
        , style "width" "100%"
        , style "font" "inherit"
        , style "line-height" "1.5em"
        ]
        (option [ Html.Attributes.selected <| Nothing == selected ]
            [ Html.text notSelectedLabel ]
            :: List.indexedMap
                (\index v ->
                    option
                        [ value v
                        , Html.Attributes.selected <| Just index == selected
                        ]
                        [ Html.text v ]
                )
                strData
        )
        |> html
        |> el
            ([ behindContent <|
                el
                    [ alignRight
                    , centerY
                    , moveLeft 10
                    ]
                <|
                    html <|
                        div
                            [ style "border-top" <| "12px solid " ++ Color.toCss Color.primary
                            , style "border-right" "8px solid transparent"
                            , style "border-bottom" "0px solid transparent"
                            , style "border-left" "8px solid transparent"
                            ]
                            []
             ]
                ++ attrs
            )


main : Html String
main =
    layout [ padding 64 ] <|
        view
            [ Element.width <| fill ]
            { data = [ "banana", "orange", "apple" ]
            , toString = identity
            , selected = Just 1
            , msg =
                Maybe.map (String.fromInt >> (++) "select : ")
                    >> Maybe.withDefault "not select"
                    >> Debug.log "message"
            , notSelectedLabel = "Choose your favorite"
            }
