module Ui.Basic exposing (focusedStyle, font, onEnter, style, tabindex, wrappedText)

import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
import Html.Events exposing (on)
import Keyboard.Event exposing (considerKeyboardEvent)
import Keyboard.Key as Key
import Ui.Color as Color


focusedStyle : Attribute msg
focusedStyle =
    focused
        [ Border.shadow
            { offset = ( 0, 0 )
            , size = 2
            , blur = 1
            , color = Color.uiColor Color.hinemos
            }
        ]


font : List (Attribute msg)
font =
    [ Font.family
        [ Font.external
            { url = "https://fonts.googleapis.com/css?family=Barlow+Semi+Condensed&display=swap"
            , name = "Barlow Semi Condensed"
            }
        , Font.sansSerif
        ]
    , Font.size 20
    , Font.color <| Color.uiColor Color.font
    ]


tabindex : Attribute msg
tabindex =
    htmlAttribute <| Html.Attributes.tabindex 0


onEnter : msg -> Attribute msg
onEnter msg =
    htmlAttribute <|
        on "keydown" <|
            considerKeyboardEvent
                (\{ keyCode } ->
                    if keyCode == Key.Enter then
                        Just msg

                    else
                        Nothing
                )


wrappedText : List (Attribute msg) -> String -> Element msg
wrappedText attrs str =
    paragraph attrs [ text str ]


style : String -> String -> Attribute msg
style label value =
    htmlAttribute <| Html.Attributes.style label value
