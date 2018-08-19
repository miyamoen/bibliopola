module Model.Shelf
    exposing
        ( currentShelf
        , depth
        , hasBooks
        , hasNoPage
        , isStoryMode
        , moveToRoot
        , name
        , openAllShelves
        , pages
        , path
        , pathString
        , route
        , selectedStory
        , setStories
        , state
        , stories
        , takeBook
        , toggleShelf
        , toggleStoryMode
        )

import Dict exposing (Dict)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Model.Book as Book
import Route exposing (Path, Query, Route(BadUrl, View))
import SelectList exposing (SelectList)
import Types exposing (..)


moveToRoot : Shelf s v -> Shelf s v
moveToRoot (Shelf zipper) =
    Shelf <| Zipper.root zipper


takeBook : Path -> Shelf s v -> Maybe (Book s v)
takeBook path shelf =
    takeBookHelp path shelf
        |> Maybe.map Zipper.current


takeBookHelp : List String -> Shelf s v -> Maybe (Zipper (Book s v))
takeBookHelp path (Shelf zipper) =
    Zipper.openPath (\path book -> Book.name book == path) path zipper
        |> Result.toMaybe


openAllShelves : Shelf s v -> List (Shelf s v)
openAllShelves ((Shelf zipper) as shelf) =
    if state shelf == Close then
        [ shelf ]
    else
        shelf
            :: (Zipper.openAll zipper
                    |> List.concatMap (Shelf >> openAllShelves)
               )


currentShelf : Model s v -> Maybe (Shelf s v)
currentShelf { route, shelf } =
    case route of
        BadUrl _ ->
            Nothing

        View path _ ->
            takeBookHelp path shelf
                |> Maybe.map Shelf



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


toggleStoryMode : Shelf s v -> Shelf s v
toggleStoryMode shelf =
    updateBook Book.toggleStoryMode shelf


setStories : List ( String, SelectList String ) -> Shelf s v -> Shelf s v
setStories stories shelf =
    updateBook (Book.setStories stories) shelf



-- Query


hasNoPage : Shelf s v -> Bool
hasNoPage shelf =
    mapBook Book.hasNoPage shelf


hasBooks : Shelf s v -> Bool
hasBooks (Shelf zipper) =
    not <| Zipper.isEmpty zipper


isStoryMode : Shelf s v -> Bool
isStoryMode shelf =
    mapBook Book.isStoryMode shelf


pages : Shelf s v -> Dict String (LazyElement s v)
pages shelf =
    mapBook Book.pages shelf


stories : Shelf s v -> List ( String, SelectList String )
stories shelf =
    mapBook Book.stories shelf


selectedStory : Shelf s v -> List ( String, String )
selectedStory shelf =
    mapBook Book.selectedStory shelf


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
        if isStoryMode shelf then
            selectedStory shelf
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
