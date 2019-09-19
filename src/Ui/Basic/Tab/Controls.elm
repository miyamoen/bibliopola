module Ui.Basic.Tab.Controls exposing (Config, view)

import Color
import Color.Manipulate as Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Html.Attributes
import SelectList exposing (SelectList)
import Ui.Basic exposing (..)
import Ui.Color as Color exposing (white)


type alias Config tab msg =
    { tabs : SelectList tab
    , onSelect : SelectList tab -> msg
    , toLabel : tab -> String
    }


view : List (Attribute msg) -> Config tab msg -> Element msg
view attrs config =
    row attrs
        [ column
            [ width fill
            , height fill
            , scrollbarY
            , spacing 2
            , htmlAttribute <| Html.Attributes.tabindex 0
            ]
          <|
            SelectList.selectedMap (viewSingle config) config.tabs
        , el
            [ width <| px 8
            , height fill
            , Background.color <| Color.uiColor Color.aiirohatoba
            ]
            none
        ]


viewSingle : Config tab msg -> SelectList.Position -> SelectList tab -> Element msg
viewSingle { onSelect, toLabel } pos tabs =
    let
        current =
            SelectList.selected tabs
    in
    el
        [ width fill
        , paddingXY 16 8
        , onClick <| onSelect tabs
        , pointer
        , Border.roundEach
            { topLeft = 4
            , topRight = 0
            , bottomLeft = 4
            , bottomRight = 0
            }
        , Background.color <|
            Color.uiColor <|
                if pos == SelectList.Selected then
                    Color.aiirohatoba

                else
                    Color.hinemos
        , Font.color <|
            Color.uiColor <|
                if pos == SelectList.Selected then
                    Color.fontLight

                else
                    Color.fontLight
        ]
    <|
        text <|
            toLabel current
