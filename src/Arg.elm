module Arg exposing
    ( fromGenerator, fromList, withGenerator
    , step, toArgView
    )

{-|


## public function

@docs fromGenerator, fromList, withGenerator


## internal function

@docs step, toArgView

-}

import List.Extra as List
import Random exposing (Generator)
import Random.Extra as Random
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


step : ArgType a -> PageSeed -> ( a, PageSeed )
step arg pageSeed =
    case arg of
        GenArg gen ->
            stepGen gen pageSeed

        ListArg item list ->
            stepList item list pageSeed

        GenOrListArg gen item list ->
            case List.head pageSeed.selects |> Maybe.map .type_ of
                Just ListArgSelect ->
                    stepList item list pageSeed

                _ ->
                    ( stepGen gen pageSeed
                        |> Tuple.first
                    , stepList item list pageSeed
                        |> Tuple.second
                    )


stepGen : Generator a -> PageSeed -> ( a, PageSeed )
stepGen gen { seed, selects } =
    let
        ( a, nextSeed ) =
            Random.step gen seed
    in
    ( a
    , { seed = nextSeed
      , selects = List.tail selects |> Maybe.withDefault []
      }
    )


stepList : a -> List a -> PageSeed -> ( a, PageSeed )
stepList item list { seed, selects } =
    let
        ( randomValue, nextSeed ) =
            Random.step (Random.uniform item list) seed

        ( select, nextPageSeed ) =
            case selects of
                selectHead :: rest ->
                    ( selectHead
                    , { seed = nextSeed
                      , selects = rest
                      }
                    )

                [] ->
                    ( randomArgSelect
                    , { seed = nextSeed
                      , selects = []
                      }
                    )
    in
    case select.type_ of
        ListArgSelect ->
            ( if select.index == Just 0 then
                item

              else
                Maybe.andThen (\index -> List.getAt (index - 1) list) select.index
                    |> Maybe.withDefault item
            , nextPageSeed
            )

        RandomArgSelect ->
            ( randomValue, nextPageSeed )


randomArgSelect : ArgSelect
randomArgSelect =
    { type_ = RandomArgSelect, index = Nothing }


toArgView : Arg a -> a -> ArgView
toArgView arg value =
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
