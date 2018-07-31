module Organism.ViewItem exposing (view)

import Element exposing (..)
import Lazy
import Model.ViewTree as ViewTree exposing (OpenPathError(..), OpenStoryError(..))
import Route exposing (Path, Query)
import Types exposing (..)


view : Path -> Query -> Model s v -> MyElement s v
view paths queries model =
    let
        res =
            model.views
                |> ViewTree.openPath paths
                |> Result.mapError PathError
                |> Result.andThen
                    (ViewTree.openStory queries >> Result.mapError QueryError)
                |> Result.map Lazy.force
    in
    case res of
        Ok element ->
            Element.mapAll identity Child ChildVar element

        Err (PathError (PathNotFound path)) ->
            textLayout Text
                []
                [ text <| String.join "/" path ++ " dose not match ViewItem." ]

        Err (QueryError DefaultStoryNotFound) ->
            textLayout Text
                []
                [ text "default story is not set." ]

        Err (QueryError (StoryArityError key)) ->
            textLayout Text
                []
                [ text <| "Argument " ++ key ++ " is not found in query." ]

        Err (QueryError (StoryNotFound storyList)) ->
            textLayout Text
                []
                [ text <| "view " ++ String.join " " storyList ++ " is not found." ]


type OpenError
    = PathError OpenPathError
    | QueryError OpenStoryError
