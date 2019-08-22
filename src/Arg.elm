module Arg exposing
    ( fromGenerator, fromList, withGenerator, view
    , consumePageArg, toPageViewAcc
    )

{-|


## public function

@docs fromGenerator, fromList, withGenerator, view


## internal function

@docs consumePageArg, toPageViewAcc, singleView

-}

import Element exposing (..)
import Element.Input
import List.Extra as List
import Random exposing (Generator)
import Random.Extra as Random
import SelectList exposing (SelectList)
import Types exposing (..)


fromGenerator : String -> ToString a -> Generator a -> Arg a
fromGenerator label toString gen =
    { label = label
    , toString = toString
    , type_ = GenArg gen
    }


fromList : String -> ToString a -> a -> List a -> Arg a
fromList label toString item list =
    { label = label
    , toString = toString
    , type_ = ListArg item list
    }


{-| 古いのと新しいのが半々の確率でくっつく。
-}
withGenerator : Generator a -> Arg a -> Arg a
withGenerator gen arg =
    { arg
        | type_ =
            case arg.type_ of
                GenArg old ->
                    GenArg <| Random.choices old [ gen ]

                ListArg item list ->
                    GenOrListArg gen item list

                GenOrListArg old item list ->
                    GenOrListArg (Random.choices old [ gen ]) item list
    }


consumePageArg : PageArg -> ArgType a -> ( a, PageArg )
consumePageArg bookArg arg =
    case arg of
        GenArg gen ->
            consumePageArgGenHelp bookArg gen

        ListArg item list ->
            consumePageArgListHelp bookArg item list

        GenOrListArg gen item list ->
            case List.head bookArg.selects |> Maybe.withDefault RandomArgSelect of
                RandomArgSelect ->
                    ( consumePageArgGenHelp bookArg gen
                        |> Tuple.first
                    , consumePageArgListHelp bookArg item list
                        |> Tuple.second
                    )

                ArgSelect _ ->
                    consumePageArgGenHelp bookArg gen


consumePageArgGenHelp : PageArg -> Generator a -> ( a, PageArg )
consumePageArgGenHelp { seed, selects } gen =
    let
        ( a, nextSeed ) =
            Random.step gen seed
    in
    ( a
    , { seed = nextSeed
      , selects = List.tail selects |> Maybe.withDefault []
      }
    )


consumePageArgListHelp : PageArg -> a -> List a -> ( a, PageArg )
consumePageArgListHelp { seed, selects } item list =
    let
        ( randomA, nextSeed ) =
            Random.step (Random.uniform item list) seed

        select =
            List.head selects |> Maybe.withDefault RandomArgSelect

        nextSelects =
            List.tail selects |> Maybe.withDefault []
    in
    case select of
        ArgSelect index ->
            ( if index == 0 then
                item

              else
                List.getAt (index + 1) list
                    |> Maybe.withDefault item
            , { seed = nextSeed
              , selects = nextSelects
              }
            )

        RandomArgSelect ->
            ( randomA
            , { seed = nextSeed
              , selects = nextSelects
              }
            )


toPageViewAcc : Arg a -> a -> PageViewAcc
toPageViewAcc arg value =
    { type_ = toViewType arg
    , label = arg.label
    , value = arg.toString value
    }


toViewType : Arg a -> ArgViewType
toViewType { type_, toString } =
    case type_ of
        GenArg _ ->
            RandomArgView

        ListArg item list ->
            ListArgView (toString item) <| List.map toString list

        GenOrListArg _ item list ->
            ListArgView (toString item) <| List.map toString list


view : List ArgSelect -> List PageViewAcc -> Element PageMsg
view selects args =
    let
        integrated =
            List.indexedMap
                (\index arg ->
                    ( arg
                    , List.getAt index selects
                        |> Maybe.withDefault RandomArgSelect
                    )
                )
                args
    in
    column [ spacing 32 ] <| SelectList.selectedMapForList singleView integrated


singleView : SelectList ( PageViewAcc, ArgSelect ) -> Element PageMsg
singleView list =
    let
        ( arg, select ) =
            SelectList.selected list
    in
    column [ spacing 16 ]
        [ row [ spacing 16 ] [ text arg.label, text " : ", text arg.value ]
        , Element.Input.radio
        []
        { onChange : option -> msg
        , options : List.List (Element.Input.Option option msg)
        , selected : Just select
        , label : Element.Input.labelRight [] <| text "test" }

        case arg.type_ of
            RandomArgView ->
                text "引数は生成されるよぅ"

            ListArgView item list  ->
                text "リストを表示する"
        ]
