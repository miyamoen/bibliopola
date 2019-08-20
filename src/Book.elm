module Book exposing (bindHtml, consumeBookArg, fold, fold1)

import Element exposing (Element)
import Html exposing (Html)
import List.Extra as List
import Random exposing (Generator)
import Types exposing (..)


htmlStitcher : (msg -> String) -> Stitcher (Html msg)
htmlStitcher msgToString =
    \html -> HtmlPage <| Html.map (msgToString >> LogMsg) html


elementStitcher : (msg -> String) -> Stitcher (Element msg)
elementStitcher msgToString =
    \element -> ElementPage <| Element.map (msgToString >> LogMsg) element



-- mapHtml : Html msg ->


fold : view -> UnboundBook view
fold view =
    \{ seed, selects } -> UnboundPage view


fold1 : (a -> view) -> Arg a -> UnboundBook view
fold1 view argA =
    \bookArg ->
        let
            ( a, bookArgA ) =
                consumeBookArg bookArg argA
        in
        UnboundPage <| view a


fold2 : (a -> b -> view) -> Arg a -> Arg b -> UnboundBook view
fold2 view argA argB =
    \bookArg ->
        let
            ( a, bookArgA ) =
                consumeBookArg bookArg argA

            ( b, bookArgB ) =
                consumeBookArg bookArgA argB
        in
        UnboundPage <| view a b


consumeBookArg : BookArg -> Arg a -> ( a, BookArg )
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


bindHtml : UnboundBook (Html PageMsg) -> Book
bindHtml unbound =
    -- \arg -> HtmlPage <| unbound arg
    Debug.todo "String.String"



-- bind : (a -> view) -> Arg a ->
