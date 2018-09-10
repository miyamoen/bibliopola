module Atom.Log exposing (view)

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
        , paddingEach { zero | bottom = space 1 }
        , Border.color Color.alphaGrey
        , Border.widthEach { zero | bottom = borderWidth 1 }
        ]
        [ el
            [ width <| px 50
            , paddingEach { zero | right = space 1 }
            , Font.alignRight
            , Border.widthEach { zero | right = borderWidth 1 }
            ]
          <|
            text <|
                String.fromInt id
        , paragraph [] [ text message ]
        ]
