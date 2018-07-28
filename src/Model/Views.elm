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


attemptOpenPath : List String -> Zipper (ViewItem s v) -> Zipper (ViewItem s v)
attemptOpenPath paths zipper =
    openPath paths zipper
        |> Result.withDefault zipper


openPath : List String -> Zipper (ViewItem s v) -> Result String (Zipper (ViewItem s v))
openPath paths zipper =
    Zipper.openPath (\path item -> item.name == path) paths zipper


openStory :
    Dict String String
    -> Zipper (ViewItem s v)
    -> Result String (Lazy (Element s v (Msg s v)))
openStory queries zipper =
    let
        viewItem =
            Zipper.current zipper
    in
    if Dict.isEmpty queries then
        Dict.get "default" viewItem.variations
            |> Result.fromMaybe "default story is not found"
    else
        viewItem.stories
            |> List.map
                (\( key, _ ) ->
                    Dict.get key queries
                        |> Result.fromMaybe (String.concat [ "story key : ", key, " is not found" ])
                )
            |> combine
            |> Result.map (String.join "/")
            |> Result.andThen
                (\s ->
                    Dict.get s viewItem.variations
                        |> Result.fromMaybe (String.concat [ "story : ", s, " is not found" ])
                )


combine : List (Result x a) -> Result x (List a)
combine =
    List.foldr (Result.map2 (::)) (Ok [])


openRecursively : Zipper (ViewItem s v) -> List (Zipper (ViewItem s v))
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


toggleTree : Zipper (ViewItem s v) -> Zipper (ViewItem s v)
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
