module Arg exposing
    ( fromGenerator, fromList, withGenerator
    , consumePageArg, toArgView
    )

{-|


## public function

@docs fromGenerator, fromList, withGenerator


## internal function

@docs consumePageArg, toArgView

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


consumePageArg : PageArg -> ArgType a -> ( a, PageArg )
consumePageArg bookArg arg =
    case arg of
        GenArg gen ->
            consumePageArgGenHelp bookArg gen

        ListArg item list ->
            consumePageArgListHelp bookArg item list

        GenOrListArg gen item list ->
            case List.head bookArg.selects |> Maybe.map .type_ |> Maybe.withDefault RandomArgSelect of
                RandomArgSelect ->
                    ( consumePageArgGenHelp bookArg gen
                        |> Tuple.first
                    , consumePageArgListHelp bookArg item list
                        |> Tuple.second
                    )

                ListArgSelect ->
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
            List.head selects |> Maybe.withDefault randomArgSelect

        nextSelects =
            List.tail selects |> Maybe.withDefault []
    in
    case select.type_ of
        ListArgSelect ->
            ( if select.index == Just 0 then
                item

              else
                Maybe.andThen (\index -> List.getAt (index - 1) list) select.index
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
