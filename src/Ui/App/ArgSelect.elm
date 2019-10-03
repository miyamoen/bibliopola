module Ui.App.ArgSelect exposing (singleView, view)

import Browser
import Element exposing (..)
import Element.Border as Border
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
    column ([ spacing 64 ] ++ attrs) <|
        SelectList.selectedMapForList singleView integrated


singleView : SelectList ( ArgView, ArgSelect ) -> Element PageMsg
singleView args =
    let
        ( arg, select ) =
            SelectList.selected args

        selects =
            SelectList.map Tuple.second args
    in
    column [ width fill, spacing 16 ]
        [ row [ width fill, spacing 16 ]
            [ wrappedText (Card.headerAttributes ++ [ width shrink, paddingXY 16 8, Border.rounded 2 ]) arg.label
            , wrappedText [ width fill, style "word-wrap" "break-word" ] arg.value
            ]
        , el [ paddingEach { top = 0, right = 0, bottom = 0, left = 32 } ] <|
            case arg.type_ of
                RandomArgView ->
                    randomRadio selects

                ListArgView item list ->
                    column [ spacing 16 ]
                        [ randomRadio selects
                        , listRadio selects (item :: list)
                        ]
        ]


randomRadio : SelectList ArgSelect -> Element PageMsg
randomRadio selects =
    Radio.view []
        { selected = (SelectList.selected selects |> .type_) == RandomArgSelect
        , msg = changeArgType selects RandomArgSelect
        , label = "Generate random value"
        }


listRadio : SelectList ArgSelect -> List String -> Element PageMsg
listRadio selects data =
    let
        select =
            SelectList.selected selects
    in
    row [ spacing 8, width fill ]
        [ Radio.view []
            { selected = select.type_ == ListArgSelect
            , msg = changeArgType selects ListArgSelect
            , label =
                "Select from list"
            }
        , Select.view [ style "max-width" "80%" ]
            { data = data
            , toString = identity
            , selected = select.index
            , notSelectedLabel = "Choose an Arg"
            , msg = changeArgIndex selects
            }
        ]


changeArgType : SelectList ArgSelect -> ArgSelectType -> PageMsg
changeArgType args type_ =
    SelectList.updateSelected (\select_ -> { select_ | type_ = type_ }) args
        |> SelectList.toList
        |> ChangeArgSelects


changeArgIndex : SelectList ArgSelect -> Maybe Int -> PageMsg
changeArgIndex args index =
    SelectList.updateSelected (\select_ -> { select_ | index = index }) args
        |> SelectList.toList
        |> ChangeArgSelects


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
