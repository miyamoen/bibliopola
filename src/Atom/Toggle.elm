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
                    , "background-color"
                        => (if on then
                                "rgb(139, 190, 236)"
                            else
                                "rgb(255,255,255)"
                           )
                    ]
                ]
            <|
                el None
                    [ width <| px 16
                    , height <| px 16
                    , inlineStyle
                        [ "border-radius" => "8px"
                        , "background-color" => "rgb(45, 129, 204)"
                        , "transform"
                            => (if on then
                                    "translateX(24px)"
                                else
                                    "translateX(0px)"
                               )
                        ]
                    ]
                    empty
        ]
