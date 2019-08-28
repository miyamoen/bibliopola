module Page exposing (fold, fold1, fold2, map, sample)

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
                    Arg.consumePageArg pageArgA argA.type_
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
                    Arg.consumePageArg pageArgA argA.type_

                ( b, pageArgC ) =
                    Arg.consumePageArg pageArgB argB.type_
            in
            ( view a b
            , [ Arg.toArgView argA a
              , Arg.toArgView argB b
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


toPageModel : (msg -> String) -> (view -> Html msg) -> Seed -> Page view -> PageModel
toPageModel msgToString toHtml seed page =
    { label = page.label
    , seeds = SelectList.fromLists [] seed []
    , selects = []
    , view =
        \attrs seeds selects ->
            let
                ( view, acc ) =
                    page.view
                        { seed = SelectList.selected seeds
                        , selects = selects
                        }
            in
            column [ width fill, height fill, spacing 64 ]
                [ toHtml view
                    |> Html.map (msgToString >> LogMsg)
                    |> html
                    |> el attrs
                , seedView seeds

                -- , Arg.view selects acc
                ]
    }


seedView : SelectList Seed -> Element PageMsg
seedView seeds =
    column []
        [ row [ spacing 32 ]
            [ text "current seed :"
            , text <| seedToString <| SelectList.selected seeds
            ]
        , Element.Input.button []
            { onPress = Just RequireNewSeed, label = text "new seed" }
        ]


seedToString : Seed -> String
seedToString seed =
    Random.step (Random.String.string 8 Random.Char.lowerCaseLatin) seed
        |> Tuple.first
