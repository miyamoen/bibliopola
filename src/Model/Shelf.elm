module Model.Shelf
    exposing
        ( OpenPathError(..)
        , OpenStoryError(..)
        , attemptOpenPath
        , currentViewTree
        , depth
        , hasBooks
        , hasNoStory
        , isOptionMode
        , moveToRoot
        , name
        , openPath
        , openRecursively
        , openStory
        , options
        , path
        , pathString
        , route
        , selectedOptions
        , setOptions
        , state
        , toggleOptionMode
        , toggleShelf
        )

import Dict exposing (Dict)
import Element exposing (Element)
import Lazy exposing (Lazy)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Model.Book as Book
import Route exposing (Path, Query, Route(BadUrl, View))
import SelectList exposing (SelectList)
import Types exposing (..)


type OpenPathError
    = PathNotFound (List String)


type OpenStoryError
    = DefaultStoryNotFound
    | StoryArityError String
    | StoryNotFound (List String)


moveToRoot : Shelf s v -> Shelf s v
moveToRoot (Shelf zipper) =
    Shelf <| Zipper.root zipper


attemptOpenPath : Path -> Shelf s v -> Shelf s v
attemptOpenPath paths zipper =
    openPath paths zipper
        |> Result.withDefault zipper


openPath : Path -> Shelf s v -> Result OpenPathError (Shelf s v)
openPath path (Shelf zipper) =
    Zipper.openPath (\path (Book book) -> book.name == path) path zipper
        |> Result.map Shelf
        |> Result.mapError (\_ -> PathNotFound path)


openStory : Query -> Shelf s v -> Result OpenStoryError (Lazy (Element s v (Msg s v)))
openStory query ((Shelf zipper) as shelf) =
    if Dict.isEmpty query then
        openDefaultStory shelf
    else
        storyList shelf query
            |> Result.andThen
                (\storyList ->
                    Zipper.current zipper
                        |> Book.stories
                        |> Dict.get (String.join "/" storyList)
                        |> Result.fromMaybe (StoryNotFound storyList)
                )


storyList : Shelf s v -> Query -> Result OpenStoryError (List String)
storyList (Shelf zipper) query =
    Zipper.current zipper
        |> Book.options
        |> List.map
            (\( key, _ ) ->
                Dict.get key query
                    |> Result.fromMaybe (StoryArityError key)
            )
        |> listCombine


openDefaultStory : Shelf s v -> Result OpenStoryError (LazyElement s v)
openDefaultStory (Shelf zipper) =
    Zipper.current zipper
        |> Book.stories
        |> Dict.get "default"
        |> Result.fromMaybe DefaultStoryNotFound


listCombine : List (Result x a) -> Result x (List a)
listCombine =
    List.foldr (Result.map2 (::)) (Ok [])


openRecursively : Shelf s v -> List (Shelf s v)
openRecursively ((Shelf zipper) as shelf) =
    if (Zipper.current zipper |> Book.state) == Close then
        [ shelf ]
    else
        shelf
            :: (Zipper.openAll zipper
                    |> List.concatMap (Shelf >> openRecursively)
               )


currentViewTree : Model s v -> Maybe (Shelf s v)
currentViewTree { route, shelf } =
    case route of
        BadUrl _ ->
            Nothing

        View path _ ->
            openPath path shelf
                |> Result.toMaybe



-- target Book


updateBook : (Book s v -> Book s v) -> Shelf s v -> Shelf s v
updateBook f (Shelf zipper) =
    Shelf <| Zipper.updateItem f zipper


mapBook : (Book s v -> a) -> Shelf s v -> a
mapBook f (Shelf zipper) =
    Zipper.current zipper |> f


toggleShelf : Shelf s v -> Shelf s v
toggleShelf shelf =
    updateBook Book.toggle shelf


toggleOptionMode : Shelf s v -> Shelf s v
toggleOptionMode shelf =
    updateBook Book.toggleOptionMode shelf


setOptions : List ( String, SelectList String ) -> Shelf s v -> Shelf s v
setOptions options shelf =
    updateBook (Book.setOptions options) shelf



-- Query


hasNoStory : Shelf s v -> Bool
hasNoStory shelf =
    mapBook Book.hasNoStory shelf


hasBooks : Shelf s v -> Bool
hasBooks (Shelf zipper) =
    not <| Zipper.isEmpty zipper


isOptionMode : Shelf s v -> Bool
isOptionMode shelf =
    mapBook Book.isOptionMode shelf


options : Shelf s v -> List ( String, SelectList String )
options shelf =
    mapBook Book.options shelf


selectedOptions : Shelf s v -> List ( String, String )
selectedOptions shelf =
    mapBook Book.selectedOptions shelf


state : Shelf s v -> State
state shelf =
    mapBook Book.state shelf


name : Shelf s v -> String
name shelf =
    mapBook Book.name shelf


depth : Shelf s v -> Int
depth (Shelf zipper) =
    Zipper.breadcrumbs zipper
        |> List.length



-- Route


route : Shelf s v -> Route
route shelf =
    View (path shelf) <|
        if isOptionMode shelf then
            selectedOptions shelf
                |> Dict.fromList
        else
            Dict.empty


path : Shelf s v -> List String
path (Shelf zipper) =
    Zipper.getPath Book.name zipper
        |> List.tail
        |> Maybe.withDefault []


pathString : Shelf s v -> String
pathString shelf =
    path shelf
        |> String.join "/"
