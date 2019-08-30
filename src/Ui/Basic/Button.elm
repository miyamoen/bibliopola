module Ui.Basic.Button exposing (Config, view)

import Browser
import Color
import Color.Manipulate as Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Ui.Basic exposing (..)
import Ui.Color as Color exposing (white)


type alias Config msg =
    { color : Color.Color
    , msg : msg
    , label : Element msg
    , disabled : Bool
    }


view : List (Attribute msg) -> Config msg -> Element msg
view attrs { color, msg, label, disabled } =
    el attrs <|
        row
            ([ width fill
             , height fill
             , paddingXY 32 16
             , tabindex
             , focusedStyle
             , Font.color <| Color.uiColor white
             ]
                ++ (if disabled then
                        [ Background.color <| Color.uiColor <| Color.fadeOut 0.4 color ]

                    else
                        [ onEnter msg
                        , onClick msg
                        , Background.color <| Color.uiColor color
                        , pointer
                        ]
                   )
            )
            [ label ]


main : Program () String String
main =
    Browser.sandbox
        { init = "init"
        , view =
            \model ->
                layout ([ padding 64 ] ++ font) <|
                    column [ spacing 16 ]
                        [ view []
                            { color = Color.samuzora
                            , msg = "first"
                            , label = text "first"
                            , disabled = False
                            }
                        , view []
                            { color = Color.samuzora
                            , msg = "second"
                            , label = text "second"
                            , disabled = True
                            }
                        , view []
                            { color = Color.aoki
                            , msg = "third"
                            , label = text "third"
                            , disabled = False
                            }
                        , view []
                            { color = Color.aoki
                            , msg = "fourth"
                            , label = text "fourth"
                            , disabled = True
                            }
                        ]
        , update = \msg _ -> Debug.log "msg" msg
        }
