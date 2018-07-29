module Model.ViewTree
    exposing
        ( attemptOpenPath
        , getPath
        , isEmpty
        , openPath
        , openRecursively
        , openStory
        , toggleStoryMode
        , toggleTree
        )

import Dict exposing (Dict)
import Element exposing (Element)
import Lazy exposing (Lazy)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Types exposing (..)


attemptOpenPath : List String -> ViewTree s v -> ViewTree s v
attemptOpenPath paths zipper =
    openPath paths zipper
        |> Result.withDefault zipper


openPath : List String -> ViewTree s v -> Result String (ViewTree s v)
openPath paths zipper =
    Zipper.openPath (\path item -> item.name == path) paths zipper


openStory :
    Dict String String
    -> ViewTree s v
    -> Result String (Lazy (Element s v (Msg s v)))
openStory queries zipper =
    let
        viewItem =
            Zipper.current zipper
    in
    if Dict.isEmpty queries then
        Dict.get "default" viewItem.variations
            |> Result.fromMaybe "This ViewItem has no views."
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


openRecursively : ViewTree s v -> List (ViewTree s v)
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


toggleTree : ViewTree s v -> ViewTree s v
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


toggleStoryMode : ViewTree s v -> ViewTree s v
toggleStoryMode tree =
    Zipper.updateItem
        (\item ->
            let
                form =
                    item.form
            in
            { item | form = { form | storyOn = not form.storyOn } }
        )
        tree


isEmpty : ViewTree s v -> Bool
isEmpty tree =
    Zipper.current tree
        |> .variations
        |> Dict.isEmpty


getPath : ViewTree s v -> String
getPath tree =
    Zipper.getPath .name tree
        |> List.tail
        |> Maybe.map (String.join "/")
        |> Maybe.withDefault ""
