module Page exposing (fold, fold1, fold2, fold3, map, sample)

import Arg
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Input
import Html exposing (Html)
import List.Extra as List
import Random exposing (Generator, Seed)
import Random.Char
import Random.String
import SelectList exposing (SelectList)
import Types exposing (..)


map : (a -> b) -> Page a -> Page b
map f { label, view } =
    { label = label
    , view = view >> Tuple.mapFirst f
    }


fold : String -> view -> Page view
fold label view =
    { label = label
    , view = \pageArgA -> ( view, [] )
    }


fold1 : String -> (a -> view) -> Arg a -> Page view
fold1 label view argA =
    { label = label
    , view =
        \pageArgA ->
            let
                ( a, pageArgB ) =
                    Arg.step argA pageArgA
            in
            ( view a, [ Arg.toArgView argA a ] )
    }


fold2 : String -> (a -> b -> view) -> Arg a -> Arg b -> Page view
fold2 label view argA argB =
    { label = label
    , view =
        \pageArgA ->
            let
                ( a, pageArgB ) =
                    Arg.step argA pageArgA

                ( b, pageArgC ) =
                    Arg.step argB pageArgB
            in
            ( view a b
            , [ Arg.toArgView argA a
              , Arg.toArgView argB b
              ]
            )
    }


fold3 : String -> (a -> b -> c -> view) -> Arg a -> Arg b -> Arg c -> Page view
fold3 label view argA argB argC =
    { label = label
    , view =
        \pageArgA ->
            let
                ( a, pageArgB ) =
                    Arg.step argA pageArgA

                ( b, pageArgC ) =
                    Arg.step argB pageArgB

                ( c, pageArgD ) =
                    Arg.step argC pageArgC
            in
            ( view a b c
            , [ Arg.toArgView argA a
              , Arg.toArgView argB b
              , Arg.toArgView argC c
              ]
            )
    }


sample : Page (Element String)
sample =
    fold2 "sample-page"
        (\a b ->
            column [ spacing 32, width fill, height fill ]
                [ el [ onClick a ] <| text a
                , el [ onClick b ] <| text b
                ]
        )
        (Arg.fromList "list-arg" identity "a" [ "aa", "aaa", String.repeat 6 "ai" ])
        (Arg.fromGenerator "random-arg" identity <| Random.String.string 8 Random.Char.lowerCaseLatin)
