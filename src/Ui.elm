module Ui exposing (view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Types exposing (..)
import Ui.App.Main as Main
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
            Main.view [ width fill, height fill ]
                model
                { pagePath = page.label, bookPaths = [] }
                page

        BookMode book ->
            row [ width fill, height fill ]
                [ SideBar.view [ style "max-width" "20%", width fill ] book model
                , case model.route of
                    TopRoute ->
                        Ui.Page.Top.view model

                    PageRoute path ->
                        Ui.Page.Page.view [ style "max-width" "80%", width (fillPortion 4) ] path book model

                    BrokenRoute url ->
                        text <| "Broken : " ++ url

                    NotFoundRoute url ->
                        text <| "NotFound : " ++ url
                ]
