module Ui.Custom.ArgSelect exposing (singleView, view)

import Browser
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Input
import List.Extra as List
import SelectList exposing (SelectList)
import Types exposing (..)


view : List ArgSelect -> List ArgView -> Element PageMsg
view selects args =
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
    wrappedRow [ spacing 32 ] <|
        SelectList.selectedMapForList singleView integrated


singleView : SelectList ( ArgView, ArgSelect ) -> Element PageMsg
singleView args =
    let
        ( arg, select ) =
            SelectList.selected args

        typeChange type_ =
            SelectList.map Tuple.second args
                |> SelectList.updateSelected (\select_ -> { select_ | type_ = type_ })
                |> SelectList.toList
                |> SetArgSelects
    in
    column
        [ spacing 16
        , alignTop

        -- , explain Debug.todo
        -- , onClick <| Debug.log "onchange" RequireNewSeed
        ]
        [ row [ spacing 8 ] [ text arg.label, text " : ", text arg.value ]
        , case arg.type_ of
            RandomArgView ->
                text "引数は生成されるよぅ"

            ListArgView item list ->
                Element.Input.radio [ explain Debug.todo ]
                    { onChange = Debug.log "onchange" >> typeChange
                    , options =
                        [ Element.Input.option RandomArgSelect <| el [] <| text "Generate random value"
                        , Element.Input.option ListArgSelect <| el [] <| text "Select from list"
                        ]
                    , selected = Just select.type_
                    , label = Element.Input.labelHidden "ArgSelect"
                    }
        ]


main =
    Browser.sandbox
        { init = 1
        , view =
            \model ->
                layout [ padding 64 ] <|
                    view []
                        [ { type_ = ListArgView "first" [ "second", "third" ]
                          , label = "arg1"
                          , value = "first"
                          }
                        , { type_ = RandomArgView
                          , label = "arg2"
                          , value = "randomSecond"
                          }
                        ]
        , update = \msg model -> model
        }
