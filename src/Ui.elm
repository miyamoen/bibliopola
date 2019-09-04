module Ui exposing (view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Types exposing (..)
import Ui.App.BoundPage as BoundPage
import Ui.App.Explorer as Explorer
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
            BoundPage.view [ width fill, height fill ] page

        BookMode book ->
            row [ width fill, height fill ]
                [ Explorer.view [ width <| px 100, height fill ] book
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
