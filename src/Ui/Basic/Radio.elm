module Ui.Basic.Radio exposing (Config, view)

import Browser
import Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Html exposing (Html)
import Html.Attributes
import Html.Events exposing (on)
import Keyboard.Event exposing (considerKeyboardEvent)
import Keyboard.Key as Key
import List.Extra as List
import Ui.Basic exposing (..)
import Ui.Color as Color


type alias Config msg =
    { selected : Bool
    , msg : msg
    , label : String
    }


view : List (Element.Attribute msg) -> Config msg -> Element msg
view attrs { selected, msg, label } =
    -- elm-uiバグ対応。focusがバグって下のDOMにもいくのを回避
    el attrs <|
        row
            [ width fill
            , spacing 8
            , padding 8
            , htmlAttribute <| Html.Attributes.tabindex 0
            , focusedStyle
            , onClick msg
            , htmlAttribute <|
                on "keydown" <|
                    considerKeyboardEvent
                        (\{ keyCode } ->
                            if keyCode == Key.Enter then
                                Just msg

                            else
                                Nothing
                        )
            ]
            [ circle selected, text label ]


circle : Bool -> Element msg
circle checked =
    column
        [ width <| px 20
        , height <| px 20
        , Border.rounded 10
        , Border.width 3
        , Border.color <| Color.uiColor Color.primary
        , alignTop
        ]
        [ if checked then
            el
                [ width <| px 10
                , height <| px 10
                , centerX
                , centerY
                , Border.rounded 5
                , Background.color <| Color.uiColor Color.primary
                ]
                none

          else
            none
        ]


main : Program () String String
main =
    Browser.sandbox
        { init = "init"
        , view =
            \model ->
                layout [ padding 64 ] <|
                    column [ spacing 16 ]
                        [ view []
                            { selected = "first" == model
                            , msg = "first"
                            , label = "first"
                            }
                        , view []
                            { selected = "second" == model
                            , msg = "second"
                            , label = "second"
                            }
                        ]
        , update = \msg _ -> Debug.log "msg" msg
        }
