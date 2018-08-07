module Atom.LogLine exposing (view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Types exposing (..)


view : Log -> Element (Styles s) v msg
view { id, message } =
    row None
        [ spacing 5
        , inlineStyle
            [ "border-bottom" => borderCss ]
        ]
        [ el None
            [ width <| px 50
            , paddingRight 5
            , inlineStyle
                [ "text-align" => "right"
                , "border-right" => borderCss
                ]
            ]
          <|
            text <|
                toString id
        , paragraph None
            []
            [ text message ]
        ]


borderCss : String
borderCss =
    "2px solid rgba(138, 142, 180, 0.22)"
