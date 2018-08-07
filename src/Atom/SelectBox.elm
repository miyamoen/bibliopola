module Atom.SelectBox exposing (Config, view, view_)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (on, targetValue)
import Json.Decode exposing (Decoder)
import Types exposing (..)


type alias Config a msg =
    { a
        | name : String
        , onChange : String -> msg
        , options : List String
        , disabled : Bool
    }


view : Config a msg -> String -> Element (Styles s) v msg
view { name, options, onChange, disabled } selected =
    column None
        [ spacing 5 ]
        [ el Text
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
                    , on "change" <| decoder onChange
                    , if disabled then
                        attribute "disabled" ""
                      else
                        classList []
                    ]
                <|
                    List.map (option selected) options
        ]


option : String -> String -> Element (Styles s) v msg
option selected option =
    node "option" <|
        el None
            [ attribute "value" option
            , if selected == option then
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


view_ : List String -> String -> Bool -> Element (Styles s) v String
view_ options selected disabled =
    view
        { options = options
        , name = "exampleName"
        , onChange = identity
        , disabled = disabled
        }
        selected
