module Ui.Basic.Tab.Controls exposing (Config, view)

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
            , spacing 8
            , padding 16
            , htmlAttribute <| Html.Attributes.tabindex 0
            ]
          <|
            SelectList.selectedMap (viewSingle config) config.tabs
        , el
            [ width <| px 2
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
        , Border.color <| Color.uiColor Color.aiirohatoba
        , Border.widthEach <|
            if pos == SelectList.Selected then
                { right = 0, left = 0, bottom = 2, top = 0 }

            else
                { right = 0, left = 0, bottom = 0, top = 0 }
        , Font.color <| Color.uiColor <| Color.font
        ]
    <|
        text <|
            toLabel current
