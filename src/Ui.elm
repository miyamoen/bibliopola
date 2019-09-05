module Ui exposing (view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Types exposing (..)
import Ui.App.BoundPage as BoundPage
import Ui.App.Seed as Seed
import Ui.App.SideBar as SideBar
import Ui.Basic exposing (..)
import Ui.Basic.Card as Card
import Ui.Color as Color
import Ui.Page.Page
import Ui.Page.Top


view : Model -> List (Html Msg)
view model =
    [ Element.layout
        ([ width fill
         , height fill
         , Background.color <| Color.uiColor Color.basicary
         ]
            ++ font
        )
      <|
        layout model
    , Html.node "style"
        []
        [ Html.text """
:focus { outline:none; }
"""
        ]
    ]


layout : Model -> Element Msg
layout model =
    case model.mode of
        PageMode page ->
            BoundPage.view [ width fill, height fill ] page
                |> map (PageMsg { pagePath = page.label, bookPaths = [] })

        BookMode book ->
            row [ width fill, height fill ]
                [ SideBar.view [ style "width" "20%", width fill ] book model
                , case model.route of
                    TopRoute ->
                        Ui.Page.Top.view model

                    PageRoute path ->
                        Ui.Page.Page.view [ style "width" "80%", width (fillPortion 4) ] path book model

                    BrokenRoute url ->
                        text <| "Broken : " ++ url

                    NotFoundRoute url ->
                        text <| "NotFound : " ++ url
                ]
