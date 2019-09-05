module Ui.Basic.Card exposing (attributes, view)

import Browser
import Color.Manipulate as Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Ui.Basic exposing (..)
import Ui.Color as Color


attributes : List (Attribute msg)
attributes =
    [ Background.color <| Color.uiColor Color.white
    , padding 16
    , Border.rounded 2
    , Border.shadow
        { offset = ( 0, 0 )
        , size = 1
        , blur = 0
        , color = Color.uiColor Color.hinemos
        }
    ]


view : List (Attribute msg) -> { label : Element msg, content : Element msg } -> Element msg
view attrs { label, content } =
    column
        ([ Border.rounded 2
         , Border.shadow
            { offset = ( 0, 0 )
            , size = 1
            , blur = 0
            , color = Color.uiColor Color.hinemos
            }
         ]
            ++ attrs
        )
        [ row
            [ paddingXY 32 8
            , width fill
            , Background.color <| Color.uiColor Color.hinemos
            , Font.color <| Color.uiColor Color.white
            ]
            [ el [ centerX ] label ]
        , column
            [ width fill
            , height fill
            , Background.color <| Color.uiColor Color.white
            , padding 16
            ]
            [ content ]
        ]


main : Program () String String
main =
    Browser.sandbox
        { init = "init"
        , view =
            \model ->
                layout ([ padding 64, Background.color <| Color.uiColor Color.basicary ] ++ font) <|
                    column [ spacing 32 ]
                        [ column attributes [ text "card", text "test" ]
                        , view [] { label = text "title", content = text "content" }
                        , view [] { label = text "title", content = el [ width <| px 300 ] <| text "content" }
                        ]
        , update = \msg _ -> Debug.log "msg" msg
        }
