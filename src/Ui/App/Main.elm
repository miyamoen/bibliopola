module Ui.App.Main exposing (Tab(..), tabToLabel, tabs, view)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import SelectList exposing (SelectList)
import Types exposing (..)
import Ui.App.Seed as Seed
import Ui.Basic exposing (..)
import Ui.Basic.Card as Card
import Ui.Basic.Tab.Controls as TabControls
import Ui.Basic.Tab.Panel as TabPanel
import Ui.Color as Color


view : List (Attribute PageMsg) -> BoundPage -> Element PageMsg
view attrs page =
    let
        pageView =
            page.view page.seeds page.selects
    in
    column attrs
        [ column
            ([ width fill
             , height <| fillPortion 65
             , style "max-height" "65%"
             ]
                ++ Card.attributes
            )
            [ el
                (Card.headerAttributes
                    ++ [ width fill
                       , Font.size 32
                       , padding 16
                       , Background.color <| Color.uiColor Color.aiirohatoba
                       ]
                )
              <|
                text page.label
            , column [ width fill, height fill, scrollbars ] [ pageView.page [ centerX, centerY ] ]
            ]
        , row
            [ width fill
            , height <| fillPortion 35
            , style "max-height" "35%"
            , padding 4
            ]
            [ TabControls.view [ height fill ]
                { tabs = tabs
                , onSelect = Debug.toString >> LogMsg
                , toLabel = tabToLabel
                }
            , column (TabPanel.attributes ++ [ width fill ])
                [ case Args of
                    Args ->
                        pageView.args [ width fill, height fill, scrollbarY ]

                    Seed ->
                        Seed.view [] page.seeds
                ]
            ]
        ]


type Tab
    = Args
    | Seed


tabs : SelectList Tab
tabs =
    SelectList.fromLists [] Args [ Seed ]


tabToLabel : Tab -> String
tabToLabel tab =
    case tab of
        Args ->
            "args"

        Seed ->
            "seed"
