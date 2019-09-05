module Ui.App.BoundPage exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Types exposing (..)
import Ui.App.Seed as Seed
import Ui.Basic exposing (..)
import Ui.Basic.Card as Card


view : List (Attribute PageMsg) -> BoundPage -> Element PageMsg
view attrs page =
    let
        pageView =
            page.view page.seeds page.selects
    in
    column attrs
        [ Card.view [ width fill, style "height" "65%" ]
            { label = el [ Font.size 32, padding 8 ] <| text page.label
            , content = el [ width fill, height fill, scrollbars ] <| pageView.page [ centerX, centerY ]
            }
        , column [ width fill, style "height" "35%", scrollbarY, padding 32, spacing 16 ]
            [ Seed.view [] page.seeds
            , pageView.args [ width fill ]
            ]
        ]
