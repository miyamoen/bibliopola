module Book exposing (bind, bindChapter, empty, map)

import Page
import Tree
import Types exposing (..)


map : (a -> b) -> Book a -> Book b
map f book =
    Tree.map (itemMap f) book


itemMap : (a -> b) -> BookItem a -> BookItem b
itemMap f { label, pages } =
    { label = label
    , pages = List.map (Page.map f) pages
    }


empty : String -> Book view
empty label =
    Tree.singleton { label = label, pages = [] }


bind : Page view -> Book view -> Book view
bind page book =
    Tree.mapLabel (\item -> { item | pages = item.pages ++ [ page ] }) book


bindChapter : Book view -> Book view -> Book view
bindChapter chapter book =
    book |> Tree.appendChild chapter
