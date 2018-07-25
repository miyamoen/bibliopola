module Model.Views
    exposing
        ( attemptOpenPath
        , openPath
        , openRecursively
        , openStory
        , toggleTree
        )

import Dict exposing (Dict)
import Element exposing (Element)
import Lazy exposing (Lazy)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Types exposing (..)


attemptOpenPath : List String -> Zipper (View s v) -> Zipper (View s v)
attemptOpenPath paths zipper =
    openPath paths zipper
        |> Result.withDefault zipper


openPath : List String -> Zipper (View s v) -> Result String (Zipper (View s v))
openPath paths zipper =
    Zipper.openPath (\path item -> item.name == path) paths zipper


openStory :
    Dict String String
    -> Zipper (View s v)
    -> Maybe (Lazy (Element s v (Msg s v)))
openStory queries zipper =
    let
        viewItem =
            Zipper.current zipper
    in
    if Dict.isEmpty queries then
        Dict.get "default" viewItem.variations
    else
        viewItem.stories
            |> List.map (\( key, _ ) -> Dict.get key queries)
            |> combine
            |> Maybe.map (String.join "/")
            |> Maybe.andThen (\s -> Dict.get s viewItem.variations)


combine : List (Maybe a) -> Maybe (List a)
combine =
    let
        step e acc =
            case e of
                Nothing ->
                    Nothing

                Just x ->
                    Maybe.map ((::) x) acc
    in
    List.foldr step (Just [])


openRecursively : Zipper (View s v) -> List (Zipper (View s v))
openRecursively zipper =
    zipper
        :: (if (Zipper.current zipper |> .state) == Close then
                []
            else
                Zipper.openAll zipper
                    |> List.map openRecursively
                    |> List.concat
           )



-- target view item


toggleTree : Zipper (View s v) -> Zipper (View s v)
toggleTree zipper =
    Zipper.updateItem
        (\item ->
            { item
                | state =
                    case item.state of
                        Open ->
                            Close

                        Close ->
                            Open
            }
        )
        zipper
