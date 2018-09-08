module Atom.LogLine exposing (view)

import Atom.Constant exposing (..)
import Color
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Types exposing (Log)


view : Log -> Element msg
view { id, message } =
    row
        [ spacing <| space 1
        , paddingEach
            { top = 0
            , right = 0
            , bottom = space 1
            , left = 0
            }
        , Border.color Color.alphaGrey
        , Border.widthEach
            { bottom = borderWidth 1
            , left = 0
            , right = 0
            , top = 0
            }
        ]
        [ el
            [ width <| px 50
            , paddingEach
                { top = 0
                , right = space 1
                , bottom = 0
                , left = 0
                }
            , Font.alignRight
            , Border.widthEach
                { bottom = 0
                , left = 0
                , right = borderWidth 1
                , top = 0
                }
            ]
          <|
            text <|
                String.fromInt id
        , paragraph [] [ text message ]
        ]
