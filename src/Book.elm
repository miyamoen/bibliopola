module Book exposing (bind, bindChapter, empty, find, map, openPage, updatePage)

import Dict exposing (Dict)
import Lazy.Tree as Tree exposing (Tree)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Page
import Types exposing (..)


map : (a -> b) -> Book a -> Book b
map f book =
    Tree.map (itemMap f) book


itemMap : (a -> b) -> BookItem a -> BookItem b
itemMap f { label, pages } =
    { label = label
    , pages = Dict.map (\_ -> Page.map f) pages
    }


empty : String -> Book view
empty label =
    Tree.singleton { label = label, pages = Dict.empty }


bind : Page view -> Book view -> Book view
bind page book =
    Zipper.fromTree book
        |> Zipper.updateItem (\item -> { item | pages = Dict.insert page.label page item.pages })
        |> Zipper.getTree


bindChapter : Book view -> Book view -> Book view
bindChapter chapter book =
    book |> Tree.insert chapter


find : List String -> Tree (AbstractBookItem page) -> Maybe (Zipper (AbstractBookItem page))
find bookPaths tree =
    Zipper.fromTree tree
        |> findHelp bookPaths


findHelp : List String -> Zipper (AbstractBookItem page) -> Maybe (Zipper (AbstractBookItem page))
findHelp paths zipper =
    case paths of
        path :: rest ->
            Zipper.open (.label >> (==) path) zipper
                |> Maybe.andThen (findHelp rest)

        [] ->
            Just zipper


openPage : String -> Zipper (AbstractBookItem page) -> Maybe page
openPage path zipper =
    Zipper.current zipper
        |> .pages
        |> Dict.get path


updatePage : PagePath -> (BoundPage -> ( BoundPage, Cmd PageMsg )) -> BoundBook -> ( BoundBook, Cmd PageMsg )
updatePage { pagePath, bookPaths } f book =
    find bookPaths book
        |> Maybe.map (updatePageHelp pagePath f >> Tuple.mapFirst (Zipper.root >> Zipper.getTree))
        |> Maybe.withDefault ( book, Cmd.none )


updatePageHelp : String -> (BoundPage -> ( BoundPage, Cmd PageMsg )) -> Zipper BoundBookItem -> ( Zipper BoundBookItem, Cmd PageMsg )
updatePageHelp pagePath f book =
    case openPage pagePath book of
        Just page ->
            let
                ( newPage, cmd ) =
                    f page
            in
            ( Zipper.updateItem (\item -> { item | pages = Dict.insert pagePath newPage item.pages }) book, cmd )

        Nothing ->
            ( book, Cmd.none )
