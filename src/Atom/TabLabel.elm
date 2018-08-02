module Atom.TabLabel exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events as Events
import Reference as Ref exposing (Reference)
import Types exposing (..)


type alias Config a b msg =
    { a | name : String, onClick : Reference String b -> msg }


view : Config a b msg -> Reference String b -> Element (Styles s) v msg
view { name, onClick } selected =
    column Text
        [ paddingXY 8 5
        , if name == Ref.this selected then
            classList []
          else
            Events.onClick <| onClick <| Ref.modify (always name) selected
        , inlineStyle
            [ "cursor" => "pointer"
            , "border-radius" => "5px 5px 0px 0px"
            , "border-color" => "rgba(138, 142, 180, 0.22)"
            , "border-width" => "2px 2px 0px 2px"
            , "background-color"
                => (if name == Ref.this selected then
                        "rgb(240, 240, 240)"
                    else
                        "rgb(138, 142, 180)"
                   )
            ]
        ]
        [ text name ]
