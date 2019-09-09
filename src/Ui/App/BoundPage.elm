module Ui.App.BoundPage exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Types exposing (..)
import Ui.App.Seed as Seed
import Ui.Basic exposing (..)
import Ui.Basic.Card as Card
import Ui.Color as Color


view : List (Attribute PageMsg) -> BoundPage -> Element PageMsg
view attrs page =
    let
        pageView =
            page.view page.seeds page.selects
    in
    column attrs
        [ column ([ width fill, style "height" "65%" ] ++ Card.attributes)
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
        , column [ width fill, style "height" "35%", scrollbarY, padding 32, spacing 16 ]
            [ Seed.view [] page.seeds
            , pageView.args [ width fill ]
            ]
        ]
