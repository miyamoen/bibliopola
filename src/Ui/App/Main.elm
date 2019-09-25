module Ui.App.Main exposing (tabToLabel, view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import SelectList exposing (SelectList)
import Types exposing (..)
import Ui.App.Seed as Seed
import Ui.Basic exposing (..)
import Ui.Basic.Card as Card
import Ui.Basic.Tab.Controls as TabControls
import Ui.Basic.Tab.Panel as TabPanel
import Ui.Color as Color


view : List (Attribute Msg) -> Model -> PagePath -> BoundPage -> Element Msg
view attrs { tabs } path page =
    let
        pageView =
            page.view page.seeds page.selects
    in
    column attrs
        [ column
            [ width fill
            , height <| fillPortion 65
            , style "max-height" "65%"
            ]
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
            |> map (PageMsg path)
        , row
            [ width fill
            , height <| fillPortion 35
            , style "max-height" "35%"
            , Border.color <| Color.uiColor Color.aiirohatoba
            , Border.widthEach
                { bottom = 0, left = 0, right = 0, top = 2 }
            , Background.color <| Color.uiColor Color.shirahanoya
            ]
            [ TabControls.view [ height fill ]
                { tabs = tabs
                , onSelect = ChangeTabs
                , toLabel = tabToLabel
                }
            , (case SelectList.selected tabs of
                ArgsTab ->
                    pageView.args [ width fill, height fill, padding 8, scrollbarY ]

                SeedTab ->
                    Seed.view [ alignTop, padding 8 ] page.seeds
              )
                |> map (PageMsg path)
            ]
        ]


tabToLabel : Tab -> String
tabToLabel tab =
    case tab of
        ArgsTab ->
            "args"

        SeedTab ->
            "seed"
