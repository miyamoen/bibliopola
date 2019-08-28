module Ui.App.Page exposing (view)

import Arg
import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Events exposing (onClick)
import Element.Input
import Html exposing (Html)
import List.Extra as List
import Page
import Random exposing (Seed)
import Random.Char
import Random.String
import SelectList exposing (SelectList)
import Types exposing (..)
import Ui.App.ArgSelect as ArgSelect
import Ui.Basic exposing (..)
import Ui.Basic.Button as Button
import Ui.Basic.Card as Card
import Ui.Basic.Radio as Radio
import Ui.Basic.Select as Select
import Ui.Color as Color


type alias Config msg view =
    { toString : ToString msg
    , toElement : view -> Element msg
    , page : Page view
    }


view : Config msg view -> (List (Attribute PageMsg) -> SelectList Seed -> List ArgSelect -> Element PageMsg)
view { toString, toElement, page } attrs seeds selects =
    let
        ( actualView, argViews ) =
            page.view
                { seed = SelectList.selected seeds
                , selects = selects
                }
    in
    column
        [ width fill
        , height fill
        , spacing 32
        ]
        [ toElement actualView
            |> map (toString >> LogMsg)
            |> el (Card.attributes ++ attrs)
        , seedView seeds
        , ArgSelect.view selects argViews
        ]


seedView : SelectList Seed -> Element PageMsg
seedView seeds =
    row (Card.attributes ++ [ width fill, spacing 8 ])
        [ text "seed"
        , Select.viewS [ width <| px 120 ]
            { data = seeds
            , toString = seedToString
            , msg = ChangeSeeds
            }
        , Button.view []
            { color = Color.primary
            , msg = RequireNewSeed
            , label = text "new seed"
            , disabled = False
            }
        ]


seedToString : Seed -> String
seedToString seed =
    Random.step (Random.String.string 8 Random.Char.lowerCaseLatin) seed
        |> Tuple.first


main : Program () String String
main =
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
                        [ view
                            { toString = Debug.toString
                            , toElement = identity
                            , page = Page.sample
                            }
                            [ width fill, height fill ]
                            (SelectList.fromLists
                                [ Random.initialSeed 12
                                , Random.initialSeed 77
                                ]
                                (Random.initialSeed 3333)
                                [ Random.initialSeed 342 ]
                            )
                            [ { type_ = ListArgSelect, index = Just 3 }
                            , { type_ = RandomArgSelect, index = Nothing }
                            ]
                            |> map Debug.toString
                        ]
        , update = \msg _ -> Debug.log "msg" msg
        }
