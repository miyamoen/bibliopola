module Atom.SelectBox exposing (Config, view)

import Atom.Constant exposing (fontSize, space, zero)
import Color
import Element exposing (..)
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes as Attrs exposing (selected, size, value)
import Html.Events exposing (on, targetValue)
import Json.Decode exposing (Decoder)
import SelectList exposing (Position(..), SelectList)
import Types exposing (..)


type alias Config a msg =
    { a
        | label : String
        , onChange : SelectList String -> msg
        , disabled : Bool
    }


view : Config a msg -> SelectList String -> Element msg
view { label, onChange, disabled } selectList =
    column
        [ spacing <| space 1 ]
        [ labelEl disabled label
        , el [ width <| minimum 120 shrink ] <|
            html <|
                Html.select
                    [ size 5
                    , Attrs.disabled disabled
                    , htmlOnChange onChange selectList
                    ]
                <|
                    SelectList.selectedMap optionNode selectList
        ]


labelEl : Bool -> String -> Element msg
labelEl disabled label =
    el
        [ Font.size <| fontSize 1
        , Font.underline
        , Font.italic
        , Font.color <|
            if disabled then
                Color.grey

            else
                Color.black
        ]
    <|
        text label


optionNode : Position -> SelectList String -> Html msg
optionNode position selectList =
    let
        option =
            SelectList.selected selectList
    in
    Html.option
        [ value option
        , selected <| position == Selected
        ]
        [ Html.text option ]


htmlOnChange : (SelectList String -> msg) -> SelectList String -> Html.Attribute msg
htmlOnChange toMsg selectList =
    on "change" <|
        decoder <|
            \selected ->
                selectList
                    |> SelectList.selectHead
                    |> SelectList.attempt
                        (SelectList.selectAfterIf ((==) selected))
                    |> toMsg


decoder : (String -> msg) -> Decoder msg
decoder f =
    targetValue
        |> Json.Decode.map f
