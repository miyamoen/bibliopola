module Arg exposing
    ( fromGenerator, fromList, withGenerator
    , consumeBookArg, toView
    )

{-|


## public function

@docs fromGenerator, fromList, withGenerator


## internal function

@docs consumeBookArg, toView, listView, view

-}

import Element exposing (..)
import List.Extra as List
import Random exposing (Generator)
import Random.Extra as Random
import Types exposing (..)


fromGenerator : ToString a -> Generator a -> Arg a
fromGenerator toString gen =
    { toString = toString
    , type_ = GenArg gen
    }


fromList : ToString a -> a -> List a -> Arg a
fromList toString item list =
    { toString = toString
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


consumeBookArg : BookArg -> ArgType a -> ( a, BookArg )
consumeBookArg bookArg arg =
    case arg of
        GenArg gen ->
            consumeBookArgGenHelp bookArg gen

        ListArg item list ->
            consumeBookArgListHelp bookArg item list

        GenOrListArg gen item list ->
            case List.head bookArg.selects |> Maybe.withDefault RandomSelect of
                RandomSelect ->
                    ( consumeBookArgGenHelp bookArg gen
                        |> Tuple.first
                    , consumeBookArgListHelp bookArg item list
                        |> Tuple.second
                    )

                Select _ ->
                    consumeBookArgGenHelp bookArg gen


consumeBookArgGenHelp : BookArg -> Generator a -> ( a, BookArg )
consumeBookArgGenHelp { seed, selects } gen =
    let
        ( a, nextSeed ) =
            Random.step gen seed
    in
    ( a
    , { seed = nextSeed
      , selects = List.tail selects |> Maybe.withDefault []
      }
    )


consumeBookArgListHelp : BookArg -> a -> List a -> ( a, BookArg )
consumeBookArgListHelp { seed, selects } item list =
    let
        ( randomA, nextSeed ) =
            Random.step (Random.uniform item list) seed

        select =
            List.head selects |> Maybe.withDefault RandomSelect

        nextSelects =
            List.tail selects |> Maybe.withDefault []
    in
    case select of
        Select index ->
            ( if index == 0 then
                item

              else
                List.getAt (index + 1) list
                    |> Maybe.withDefault item
            , { seed = nextSeed
              , selects = nextSelects
              }
            )

        RandomSelect ->
            ( randomA
            , { seed = nextSeed
              , selects = nextSelects
              }
            )


toView : Arg a -> ArgView
toView { type_, toString } =
    case type_ of
        GenArg _ ->
            RandomArgView

        ListArg item list ->
            ListArgView (toString item) <| List.map toString list

        GenOrListArg _ item list ->
            ListArgView (toString item) <| List.map toString list


{-| 引数は変更頻度順
Maybe Select -- BookArg由来。あるかわかんない。なければRandom扱い
Maybe String -- 実際使ってる値を文字列化したやつ。型的にMaybeがでちゃう。bookから返してもらう予定
-}
view : ArgView -> Maybe Select -> Maybe String -> Element Msg
view arg select value =
    case arg of
        RandomArgView ->
            text "引数は生成されるよぅ"

        ListArgView string stringList ->
            text "リストを表示する"


{-| 引数は変更頻度順
List Select -- BookArg由来
List String -- 実際使ってる値を文字列化したやつ。bookから返してもらう予定
-}
listView : List ArgView -> List Select -> List String -> Element Msg
listView args selects values =
    column [] <|
        List.indexedMap
            (\index arg ->
                view arg (List.getAt index selects) (List.getAt index values)
            )
            args
