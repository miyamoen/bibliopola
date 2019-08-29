module Ui.App.ArgSelect exposing (singleView, view)

import Browser
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Input
import List.Extra as List
import SelectList exposing (SelectList)
import Types exposing (..)
import Ui.Basic exposing (..)
import Ui.Basic.Card as Card
import Ui.Basic.Radio as Radio
import Ui.Basic.Select as Select


view : List (Attribute PageMsg) -> List ArgSelect -> List ArgView -> Element PageMsg
view attrs selects args =
    let
        integrated =
            List.indexedMap
                (\index arg ->
                    ( arg
                    , List.getAt index selects
                        |> Maybe.withDefault { type_ = RandomArgSelect, index = Nothing }
                    )
                )
                args
    in
    Card.view attrs
        { label = text "args"
        , content =
            wrappedRow [ width fill, spacing 32 ] <|
                SelectList.selectedMapForList singleView integrated
        }


singleView : SelectList ( ArgView, ArgSelect ) -> Element PageMsg
singleView args =
    let
        ( arg, select ) =
            SelectList.selected args

        changeArgType type_ =
            SelectList.map Tuple.second args
                |> SelectList.updateSelected (\select_ -> { select_ | type_ = type_ })
                |> SelectList.toList
                |> ChangeArgSelects

        changeArgIndex index =
            SelectList.map Tuple.second args
                |> SelectList.updateSelected (\select_ -> { select_ | index = index })
                |> SelectList.toList
                |> ChangeArgSelects
    in
    Card.view [ alignTop ]
        { label = text arg.label
        , content =
            column [ spacing 32 ]
                [ wrappedText [] arg.value
                , case arg.type_ of
                    RandomArgView ->
                        Radio.view []
                            { selected = select.type_ == RandomArgSelect
                            , msg = changeArgType RandomArgSelect
                            , label = "Generate random value"
                            }

                    ListArgView item list ->
                        column [ spacing 16 ]
                            [ Radio.view []
                                { selected = select.type_ == RandomArgSelect
                                , msg = changeArgType RandomArgSelect
                                , label = "Generate random value"
                                }
                            , column [ spacing 8, width fill ]
                                [ Radio.view []
                                    { selected = select.type_ == ListArgSelect
                                    , msg = changeArgType ListArgSelect
                                    , label =
                                        "Select from list"
                                    }
                                , el
                                    [ width fill
                                    , paddingEach
                                        { top = 0, right = 0, bottom = 0, left = 36 }
                                    ]
                                  <|
                                    Select.view [ width fill ]
                                        { data = item :: list
                                        , toString = identity
                                        , selected = select.index
                                        , notSelectedLabel = "Choose an Arg"
                                        , msg = changeArgIndex
                                        }
                                ]
                            ]
                ]
        }


main : Program () String String
main =
    Browser.sandbox
        { init = "init"
        , view =
            \model ->
                layout (padding 64 :: font)
                    (view []
                        [ { type_ = ListArgSelect, index = Just 0 }
                        , { type_ = RandomArgSelect, index = Nothing }
                        , { type_ = RandomArgSelect, index = Nothing }
                        ]
                        [ { type_ = ListArgView "first" [ "second", "third" ]
                          , label = "arg1"
                          , value = "first"
                          }
                        , { type_ = RandomArgView
                          , label = "arg2"
                          , value = "randomSecond"
                          }
                        , { type_ = ListArgView "first" [ "second", "third" ]
                          , label = "arg2"
                          , value = "random"
                          }
                        ]
                        |> map Debug.toString
                    )
        , update = \msg _ -> Debug.log "msg" msg
        }
