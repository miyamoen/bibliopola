module Atom.SelectBox exposing (Config, view, view_)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (on, targetValue)
import Json.Decode exposing (Decoder)
import SelectList exposing (Position(..), SelectList)
import Types exposing (..)


type alias Config a msg =
    { a
        | name : String
        , onChange : SelectList String -> msg
        , disabled : Bool
    }


view : Config a msg -> SelectList String -> Element (Styles s) v msg
view { name, onChange, disabled } selectList =
    column None
        [ spacing 5 ]
        [ el None
            [ inlineStyle
                [ "text-decoration" => "underline"
                , "font-style" => "italic"
                , if disabled then
                    "color" => "rgb(150, 150, 150)"
                  else
                    "" => ""
                ]
            ]
          <|
            text name
        , el None [ paddingLeft 40, minWidth <| px 120 ] <|
            node "select" <|
                column None
                    [ attribute "size" "5"
                    , width fill
                    , paddingXY 5 2
                    , inlineStyle
                        [ "border" => "1px solid rgba(138, 142, 180, 0.22)"
                        , "border-radius" => "4px"
                        ]
                    , on "change" <|
                        decoder <|
                            \selected ->
                                SelectList.attempt
                                    (SelectList.select ((==) selected))
                                    selectList
                                    |> onChange
                    , if disabled then
                        attribute "disabled" ""
                      else
                        classList []
                    ]
                <|
                    SelectList.mapBy option selectList
        ]


option : Position -> SelectList String -> Element (Styles s) v msg
option position selectList =
    let
        option =
            SelectList.selected selectList
    in
    node "option" <|
        el None
            [ attribute "value" option
            , if position == Selected then
                attribute "selected" ""
              else
                classList []
            ]
        <|
            text option


decoder : (String -> msg) -> Decoder msg
decoder f =
    targetValue
        |> Json.Decode.map f


view_ : SelectList String -> Bool -> Element (Styles s) v (SelectList String)
view_ selectList disabled =
    view
        { name = "exampleName"
        , onChange = identity
        , disabled = disabled
        }
        selectList
