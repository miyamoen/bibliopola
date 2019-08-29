module Ui.App.Page exposing (view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Page
import Random exposing (Seed)
import SelectList exposing (SelectList)
import Types exposing (..)
import Ui.App.ArgSelect as ArgSelect
import Ui.Basic exposing (..)
import Ui.Color as Color


type alias Config msg view =
    { toString : ToString msg
    , toElement : view -> Element msg
    , page : Page view
    }


type alias View =
    { page : List (Attribute PageMsg) -> Element PageMsg
    , args : List (Attribute PageMsg) -> Element PageMsg
    }


view : Config msg view -> (SelectList Seed -> List ArgSelect -> View)
view { toString, toElement, page } seeds selects =
    let
        ( actualView, argViews ) =
            page.view
                { seed = SelectList.selected seeds
                , selects = selects
                }
    in
    { page =
        \attrs ->
            toElement actualView
                |> map (toString >> LogMsg)
                |> el attrs
    , args = \attrs -> ArgSelect.view attrs selects argViews
    }


main : Program () String String
main =
    let
        { page, args } =
            view
                { toString = Debug.toString
                , toElement = identity
                , page = Page.sample
                }
                (SelectList.singleton <| Random.initialSeed 3333)
                [ { type_ = ListArgSelect, index = Just 3 }
                , { type_ = RandomArgSelect, index = Nothing }
                ]
    in
    Browser.sandbox
        { init = "init"
        , view =
            \model ->
                layout [] <|
                    column
                        ([ padding 64
                         , width fill
                         , height fill
                         , Background.color <| Color.uiColor Color.basicary
                         ]
                            ++ font
                        )
                        [ page [] |> map Debug.toString
                        , args [] |> map Debug.toString
                        ]
        , update = \msg _ -> Debug.log "msg" msg
        }
