module Atom.Tab exposing (Config, view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events as Events
import Types exposing (..)


type alias Config a msg =
    { a | selected : Bool, onClick : msg }


view : Config a msg -> String -> Element (Styles s) v msg
view { selected, onClick } label =
    column Text
        [ paddingXY 8 5
        , width <| fillPortion 1
        , center
        , scrollbars
        , if selected then
            classList []
          else
            Events.onClick <| onClick
        , inlineStyle
            [ "cursor" => "pointer"
            , "border-radius" => "5px 5px 0px 0px"
            , "border-color" => "rgb(135, 135, 150)"
            , "border-width" => "2px 2px 0px 2px"
            , "background-color"
                => (if selected then
                        "rgb(240, 240, 240)"
                    else
                        "rgb(97, 99, 116)"
                   )
            ]
        ]
        [ text label ]
