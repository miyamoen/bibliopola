module Atom.Toggle exposing (Config, view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events as Events
import Types exposing (..)


type alias Config a msg =
    { a | name : String, onClick : msg }


view : Config a msg -> Bool -> Element (Styles s) v msg
view { name, onClick } on =
    row None
        [ spacing 5, verticalCenter, Events.onClick onClick ]
        [ el Text [] <| text name
        , el None
            [ padding 2
            , inlineStyle
                [ "border" => "2px solid rgba(138, 142, 180, 0.22)"
                , "border-radius" => "20px"
                ]
            ]
          <|
            el None
                [ width <| px 40
                , height <| px 16
                , inlineStyle
                    [ "border-radius" => "20px"
                    , "transition" => "transform .1s,background-color .1s"
                    , if on then
                        "background-color" => "rgb(139, 190, 236)"
                      else
                        "" => ""
                    ]
                ]
            <|
                el None
                    [ width <| px 16
                    , height <| px 16
                    , inlineStyle
                        [ "border-radius" => "8px"
                        , "background-color" => "rgb(45, 129, 204)"
                        , if on then
                            "transform" => "translateX(24px)"
                          else
                            "" => ""
                        ]
                    ]
                    empty
        ]
