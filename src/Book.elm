module Book exposing (bind, bindChapter, empty, map, openZipper)

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


openZipper : List String -> Tree (AbstractBookItem page) -> Maybe (Zipper (AbstractBookItem page))
openZipper bookPaths tree =
    Zipper.fromTree tree
        |> openZipperHelp bookPaths


openZipperHelp : List String -> Zipper (AbstractBookItem page) -> Maybe (Zipper (AbstractBookItem page))
openZipperHelp paths zipper =
    case paths of
        path :: rest ->
            Zipper.open (.label >> (==) path) zipper
                |> Maybe.andThen (openZipperHelp rest)

        [] ->
            Just zipper
