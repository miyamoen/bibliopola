module Ui.Basic.Select exposing (Config, ConfigS, view, viewS)

import Browser
import Element exposing (..)
import Element.Border as Border
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import List.Extra as List
import SelectList exposing (SelectList)
import Ui.Basic exposing (..)
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
        (onInput (\str -> List.findIndex ((==) str) strData |> msg) :: styles)
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
        |> toElement attrs


type alias ConfigS data msg =
    { data : SelectList data
    , toString : data -> String
    , msg : SelectList data -> msg
    }


viewS : List (Element.Attribute msg) -> ConfigS data msg -> Element msg
viewS attrs { data, toString, msg } =
    let
        strData =
            SelectList.toList data
                |> List.map toString

        change str =
            SelectList.selectWhileLoopBy
                ((List.findIndex ((==) str) strData
                    |> Maybe.withDefault 0
                 )
                    - SelectList.index data
                )
                data
                |> msg
    in
    select
        (onInput change :: styles)
        (SelectList.selectedMap
            (\pos current ->
                let
                    v =
                        toString <| SelectList.selected current
                in
                option
                    [ value v
                    , Html.Attributes.selected <| pos == SelectList.Selected
                    ]
                    [ Html.text v ]
            )
            data
        )
        |> toElement attrs


styles : List (Html.Attribute msg)
styles =
    [ style "-webkit-appearance" "none"
    , style "-moz-appearance" "none"
    , style "appearance" "none"
    , style "padding" "0.5em 1em"
    , style "border-radius" "4px"
    , style "border-color" <| Color.toCss Color.primary
    , style "border-width" "4px"
    , style "width" "100%"
    , style "font" "inherit"
    , style "line-height" "1.5em"
    , style "color" <| Color.toCss Color.font
    ]


toElement : List (Element.Attribute msg) -> Html msg -> Element msg
toElement attrs html =
    Element.html html
        |> el
            ([ behindContent <| triangle [ alignRight, centerY, moveLeft 10 ]
             , focusedStyle
             ]
                ++ attrs
            )


triangle : List (Element.Attribute msg) -> Element msg
triangle attrs =
    el ((htmlAttribute <| style "pointer-events" "none") :: attrs) <|
        html <|
            div
                [ style "border-top" <| "12px solid " ++ Color.toCss Color.primary
                , style "border-right" "8px solid transparent"
                , style "border-bottom" "0px solid transparent"
                , style "border-left" "8px solid transparent"
                ]
                []


main : Program () Int String
main =
    Browser.sandbox
        { init = 0
        , view =
            \_ ->
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
        , update = \_ _ -> 1
        }
