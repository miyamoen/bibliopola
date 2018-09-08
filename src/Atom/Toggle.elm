module Atom.Toggle exposing (Config, view)

import Atom.Constant exposing (..)
import Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Util exposing (style)


type alias Config a msg =
    { a | label : String, onClick : Bool -> msg }


view : Config a msg -> Bool -> Element msg
view { label, onClick } on =
    row
        [ spacing <| space 1
        , centerY
        , Events.onClick <| onClick <| not on
        , pointer
        ]
        [ el [ Font.size <| fontSize 2 ] <| text label
        , el
            [ padding <| space -1
            , Border.width <| borderWidth 1
            , Border.color Color.alphaGrey
            , Border.rounded 20
            ]
          <|
            el
                [ width <| px 40
                , height <| px 16
                , Border.rounded 20
                , Background.color <|
                    if on then
                        Color.greyBlue

                    else
                        Color.white
                , style "transition" "background-color .5s"
                ]
            <|
                el
                    [ width <| px 16
                    , height <| px 16
                    , Border.rounded 8
                    , Background.color Color.blue
                    , style "transition" "transform .2s"
                    , style "transform" <|
                        if on then
                            "translateX(24px)"

                        else
                            "translateX(0px)"
                    ]
                    none
        ]
