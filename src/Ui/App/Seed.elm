module Ui.App.Seed exposing (view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Random exposing (Seed)
import Random.Char
import Random.String
import SelectList exposing (SelectList)
import Types exposing (..)
import Ui.Basic exposing (..)
import Ui.Basic.Button as Button
import Ui.Basic.Card as Card
import Ui.Basic.Select as Select
import Ui.Color as Color


view : List (Attribute PageMsg) -> SelectList Seed -> Element PageMsg
view attrs seeds =
    row (Card.attributes ++ attrs)
        [ el Card.headerAttributes <| text "seed"
        , row [ spacing 8 ]
            [ Select.viewS [ width <| px 130 ]
                { data = seeds
                , toString = toString
                , msg = ChangeSeeds
                }
            , Button.view []
                { color = Color.primary
                , msg = RequireNewSeed
                , label = text "new seed"
                , disabled = False
                }
            ]
        ]


toString : Seed -> String
toString seed =
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
                        [ view []
                            (SelectList.fromLists
                                [ Random.initialSeed 12
                                , Random.initialSeed 77
                                ]
                                (Random.initialSeed 3333)
                                [ Random.initialSeed 342 ]
                            )
                            |> map Debug.toString
                        ]
        , update = \msg _ -> Debug.log "msg" msg
        }
