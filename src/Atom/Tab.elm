module Atom.Tab exposing (Config, view)

import Atom.Constant exposing (borderWidth, fontSize, roundLength, space)
import Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font


type alias Config a msg =
    { a | selected : Bool, onClick : msg }


view : Config a msg -> String -> Element msg
view { selected, onClick } label =
    el
        [ pointer
        , width fill
        , padding <| space -1
        , Font.center
        , Font.size <| fontSize 2
        , Events.onClick <| onClick
        , Background.color <|
            if selected then
                Color.white

            else
                Color.grey
        , Border.color Color.alphaGrey
        , Border.widthEach
            { bottom = 0
            , left = borderWidth 1
            , right = borderWidth 1
            , top = borderWidth 1
            }
        , Border.roundEach
            { topLeft = roundLength 1
            , topRight = roundLength 1
            , bottomLeft = 0
            , bottomRight = 0
            }
        ]
    <|
        text label
