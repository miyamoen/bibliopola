module Book exposing
    ( allPaths
    , bind
    , bindChapter
    , bindPage
    , closeAll
    , empty
    , find
    , findPage
    , getPath
    , map
    , openAll
    , openThroughPaths
    , updatePage
    )

import BoundPage
import Dict exposing (Dict)
import Lazy.Tree as Tree exposing (Tree)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Page
import Random exposing (Seed)
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


bindPage : Page view -> Book view -> Book view
bindPage page book =
    Zipper.fromTree book
        |> Zipper.updateItem (\item -> { item | pages = Dict.insert page.label page item.pages })
        |> Zipper.getTree


bindChapter : Book view -> Book view -> Book view
bindChapter chapter book =
    book |> Tree.insert chapter


bind : ViewConfig view msg -> Seed -> Book view -> BoundBook
bind config seed book =
    Tree.map
        (\{ pages, label } ->
            { label = label
            , pages = Dict.map (\_ page -> BoundPage.bind config seed page) pages
            , open = True
            }
        )
        book


allPaths : Tree (AbstractBookItem item page) -> List PagePath
allPaths book =
    Zipper.fromTree book
        |> Zipper.openAll
        |> List.concatMap
            (\zipper ->
                let
                    { pages } =
                        Zipper.current zipper
                in
                Dict.keys pages
                    |> List.map (\pagePath -> getPath pagePath zipper)
            )


getPath : String -> Zipper (AbstractBookItem item page) -> PagePath
getPath pagePath book =
    { pagePath = pagePath
    , bookPaths =
        if Zipper.isRoot book then
            []

        else
            Zipper.getPath .label book
                |> List.tail
                |> Maybe.withDefault []
    }


find : List String -> Tree (AbstractBookItem item page) -> Maybe (Zipper (AbstractBookItem item page))
find bookPaths tree =
    Zipper.fromTree tree
        |> findHelp bookPaths


findHelp : List String -> Zipper (AbstractBookItem item page) -> Maybe (Zipper (AbstractBookItem item page))
findHelp paths zipper =
    case paths of
        path :: rest ->
            Zipper.open (.label >> (==) path) zipper
                |> Maybe.andThen (findHelp rest)

        [] ->
            Just zipper


openAll : BoundBook -> BoundBook
openAll book =
    Tree.map (\item -> { item | open = True }) book


closeAll : BoundBook -> BoundBook
closeAll book =
    Tree.map (\item -> { item | open = False }) book


openThroughPaths : List String -> BoundBook -> BoundBook
openThroughPaths paths book =
    Zipper.fromTree book
        |> openThroughPathsHelp paths
        |> Zipper.root
        |> Zipper.getTree


openThroughPathsHelp : List String -> Zipper BoundBookItem -> Zipper BoundBookItem
openThroughPathsHelp paths book =
    case paths of
        path :: rest ->
            case Zipper.open (.label >> (==) path) book of
                Just newBook ->
                    openThroughPathsHelp rest (openItem book)

                Nothing ->
                    book

        [] ->
            book


openItem : Zipper BoundBookItem -> Zipper BoundBookItem
openItem book =
    if Zipper.current book |> .open then
        book

    else
        Zipper.updateItem (\item -> { item | open = True }) book


closeItem : Zipper BoundBookItem -> Zipper BoundBookItem
closeItem book =
    if Zipper.current book |> .open then
        Zipper.updateItem (\item -> { item | open = False }) book

    else
        book


findPage : String -> Zipper (AbstractBookItem item page) -> Maybe page
findPage path zipper =
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
    case findPage pagePath book of
        Just page ->
            let
                ( newPage, cmd ) =
                    f page
            in
            ( Zipper.updateItem (\item -> { item | pages = Dict.insert pagePath newPage item.pages }) book, cmd )

        Nothing ->
            ( book, Cmd.none )
