module Ui exposing (view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Types exposing (..)
import Ui.App.Seed as Seed
import Ui.Basic exposing (..)
import Ui.Basic.Card as Card
import Ui.Color as Color
import Ui.Page.Page
import Ui.Page.Top


view : Model -> Html Msg
view model =
    Element.layout
        ([ width fill
         , height fill
         , Background.color <| Color.uiColor Color.basicary
         ]
            ++ font
        )
    <|
        layout model


layout : Model -> Element Msg
layout model =
    case model.mode of
        PageMode page ->
            let
                pageView =
                    page.view page.seeds page.selects
            in
            column [ width fill, height fill ]
                [ Card.view [ width fill, height fill ]
                    { label = el [ Font.size 32, padding 8 ] <| text page.label
                    , content = pageView.page [ centerX, centerY ]
                    }
                , column [ width fill, height fill, scrollbarY, padding 32, spacing 16 ]
                    [ Seed.view [] page.seeds
                    , pageView.args [ width fill ]
                    ]
                ]
                |> map (PageMsg { pagePath = page.label, bookPaths = [] } >> Debug.log "PageMsg")

        BookMode _ ->
            row [ width fill, height fill ]
                [ column [ width <| px 100, height fill ] [ text "explorer" ]
                , router model
                ]


router : Model -> Element Msg
router model =
    case model.route of
        TopRoute ->
            Ui.Page.Top.view model

        PageRoute path ->
            Ui.Page.Page.view model

        BrokenRoute url ->
            text <| "Broken : " ++ url

        NotFoundRoute url ->
            text <| "NotFound : " ++ url
