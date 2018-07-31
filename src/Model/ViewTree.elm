module Model.ViewTree
    exposing
        ( OpenPathError(..)
        , OpenStoryError(..)
        , attemptOpenPath
        , currentViewTree
        , getFormStories
        , getPath
        , getPathString
        , getQuery
        , getRoute
        , isEmpty
        , isStoryMode
        , openPath
        , openRecursively
        , openStory
        , setFormStory
        , toggleStoryMode
        , toggleTree
        )

import Dict exposing (Dict)
import Element exposing (Element)
import Lazy exposing (Lazy)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Route exposing (Path, Query, Route(BadUrl, View))
import Types exposing (..)


type OpenPathError
    = PathNotFound (List String)


type OpenStoryError
    = DefaultStoryNotFound
    | StoryArityError String
    | StoryNotFound (List String)


attemptOpenPath : Path -> ViewTree s v -> ViewTree s v
attemptOpenPath paths zipper =
    openPath paths zipper
        |> Result.withDefault zipper


openPath : Path -> ViewTree s v -> Result OpenPathError (ViewTree s v)
openPath path zipper =
    Zipper.openPath (\path item -> item.name == path) path zipper
        |> Result.mapError (\_ -> PathNotFound path)


openStory : Query -> ViewTree s v -> Result OpenStoryError (Lazy (Element s v (Msg s v)))
openStory query tree =
    if Dict.isEmpty query then
        openDefaultStory tree
    else
        storyList tree query
            |> Result.andThen
                (\storyList ->
                    Zipper.current tree
                        |> .variations
                        |> Dict.get (String.join "/" storyList)
                        |> Result.fromMaybe (StoryNotFound storyList)
                )


storyList : ViewTree s v -> Query -> Result OpenStoryError (List String)
storyList tree query =
    Zipper.current tree
        |> .stories
        |> List.map
            (\( key, _ ) ->
                Dict.get key query
                    |> Result.fromMaybe (StoryArityError key)
            )
        |> listCombine


openDefaultStory : ViewTree s v -> Result OpenStoryError (Lazy (Element s v (Msg s v)))
openDefaultStory tree =
    Zipper.current tree
        |> .variations
        |> Dict.get "default"
        |> Result.fromMaybe DefaultStoryNotFound


listCombine : List (Result x a) -> Result x (List a)
listCombine =
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


currentViewTree : Model s v -> Maybe (ViewTree s v)
currentViewTree { route, views } =
    case route of
        BadUrl _ ->
            Nothing

        View path _ ->
            openPath path views
                |> Result.toMaybe



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


setFormStory : String -> String -> ViewTree s v -> ViewTree s v
setFormStory name story tree =
    Zipper.updateItem
        (\item ->
            let
                form =
                    item.form
            in
            { item
                | form =
                    { form | stories = Dict.insert name story form.stories }
            }
        )
        tree



-- Query


isEmpty : ViewTree s v -> Bool
isEmpty tree =
    Zipper.current tree
        |> .variations
        |> Dict.isEmpty


getPath : ViewTree s v -> List String
getPath tree =
    Zipper.getPath .name tree
        |> List.tail
        |> Maybe.withDefault []


getPathString : ViewTree s v -> String
getPathString tree =
    getPath tree
        |> String.join "/"


getQuery : ViewTree s v -> Dict String String
getQuery tree =
    Zipper.current tree
        |> .form
        |> .stories


isStoryMode : ViewTree s v -> Bool
isStoryMode tree =
    Zipper.current tree
        |> .form
        |> .storyOn


getFormStories :
    ViewTree s v
    -> List { name : String, selected : String, options : List String }
getFormStories tree =
    let
        item =
            Zipper.current tree
    in
    item.stories
        |> List.map
            (\( name, stories ) ->
                { name = name
                , options = stories
                , selected =
                    item.form.stories
                        |> Dict.get name
                        |> Maybe.withDefault ""
                }
            )


getRoute : ViewTree s v -> Route
getRoute tree =
    View (getPath tree) <|
        if isStoryMode tree then
            getQuery tree
        else
            Dict.empty
