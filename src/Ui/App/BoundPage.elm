module Ui.App.BoundPage exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Types exposing (..)
import Ui.App.Seed as Seed
import Ui.Basic exposing (..)
import Ui.Basic.Card as Card


view : List (Attribute Msg) -> BoundPage -> Element Msg
view attrs page =
    let
        pageView =
            page.view page.seeds page.selects
    in
    column attrs
        [ Card.view [ width fill, height fill ]
            { label = el [ Font.size 32, padding 8 ] <| text page.label
            , content = pageView.page [ centerX, centerY ]
            }
            |> map (PageMsg { pagePath = page.label, bookPaths = [] } >> Debug.log "PageMsg")
        , column [ width fill, height fill, scrollbarY, padding 32, spacing 16 ]
            [ Seed.view [] page.seeds
            , pageView.args [ width fill ]
            ]
            |> map (PageMsg { pagePath = page.label, bookPaths = [] } >> Debug.log "PageMsg")
        ]
