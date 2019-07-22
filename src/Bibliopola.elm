module Bibliopola exposing
    ( Program, Book, Shelf
    , fromBook, fromShelf, customProgram
    , withFrontCover
    , IntoBook, Story, intoBook, addStory, buildBook, buildHtmlBook
    , bookWithFrontCover
    , emptyShelf, shelfWith
    , addBook, addShelf
    )

{-| UI Catalog for Elm applications built by elm-ui inspired by Storybook

[demo](https://miyamoen.github.io/bibliopola/)


# Types

@docs Program, Book, Shelf


## Program

Entry point of Bibliopola

@docs fromBook, fromShelf, customProgram


# Book

@docs withFrontCover


## Build Book

@docs IntoBook, Story, intoBook, addStory, buildBook, buildHtmlBook
@docs bookWithFrontCover


# Shelf

@docs emptyShelf, shelfWith
@docs addBook, addShelf

-}

import Browser
import Dict exposing (Dict)
import Element exposing (Element)
import Html exposing (Html)
import List.Extra as List exposing (lift2)
import Model.Book as Book
import Route
import SelectList exposing (SelectList)
import Tree
import Tree.Zipper as Zipper exposing (Zipper(..))
import Types exposing (..)
import Update exposing (..)
import View exposing (view)


{-| Type for type annotation.

    main : Bibliopola.Program
    main =
        fromBook book

-}
type alias Program =
    Platform.Program () Model Msg


{-| Book has views.

Use [`intoBook`](#intoBook) or [`bookWithFrontCover`](#bookWithFrontCover).

-}
type alias Book =
    Types.Book


{-| Shelf is tree structure that has books.

    type alias Shelf =
        Tree Book

Use [`emptyShelf`](#emptyShelf) or [`shelfWith`](#shelfWith).

-}
type alias Shelf =
    Types.Shelf



-- main Program


{-|

    main : Bibliopola.Program
    main =
        fromBook book

-}
fromBook : Book -> Program
fromBook book =
    fromShelf <| shelfWith book


{-|

    main : Bibliopola.Program
    main =
        fromShelf shelf

-}
fromShelf : Shelf -> Program
fromShelf =
    customProgram { title = "", front = Nothing }


makeTitle : String -> String
makeTitle title =
    case title of
        "" ->
            "Bibliopola"

        _ ->
            title ++ " - Bibliopola"


customProgram : { title : String, front : Maybe (Element String) } -> Shelf -> Program
customProgram { title, front } shelf =
    Browser.application
        { view = \model -> { title = makeTitle title, body = [ view front model ] }
        , init = init shelf
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = onUrlRequest
        , onUrlChange = onUrlChange
        }



-- Shelf


{-| A Shelf has one book in itself.

    shelf : Shelf
    shelf =
        shelfWith ViewNum.book
            |> addBook ViewFloat.book
            |> addBook ViewInt.book

-}
shelfWith : Book -> Shelf
shelfWith book =
    Shelf <| Zipper.fromTree <| Tree.singleton book


{-| A Shelf has no books in itself.

    shelf : Shelf
    shelf =
        emptyShelf "Hello"
            |> addBook Hello.book
            |> addBook HelloYou.book

-}
emptyShelf : String -> Shelf
emptyShelf name =
    Book.empty name
        |> shelfWith


{-| Add a book to shelf.

This book becomes child of shelf.

-}
addBook : Book -> Shelf -> Shelf
addBook book (Shelf zipper) =
    Shelf <| Zipper.insert (Tree.singleton book) zipper


{-| Add a shelf to shelf.

This shelf becomes child of shelf.

    shelf : Shelf
    shelf =
        emptyShelf "Bibliopola"
            |> addShelf Atom.Index.shelf
            |> addShelf Molecule.Index.shelf
            |> addShelf Organism.Index.shelf
            |> addShelf Page.Index.shelf

-}
addShelf : Shelf -> Shelf -> Shelf
addShelf (Shelf (Zipper childTree _)) (Shelf zipper) =
    Shelf <| Zipper.insert childTree zipper



-- Book


{-| Add first view to a book.

    book : Book
    book =
        intoBook "HelloYou" identity view
            |> addStory (Story.build "name" identity [ "spam", "egg", "ham" ])
            |> buildBook
            |> withFrontCover (view "Bibliopola")

-}
withFrontCover : Element String -> Book -> Book
withFrontCover view book =
    Book.withFrontCover view book



-- Build Book


{-| Build a book that has a static `view`.

    book : Book
    book =
        bookWithFrontCover "Hello" view

-}
bookWithFrontCover : String -> Element String -> Book
bookWithFrontCover title view =
    Book.empty title
        |> Book.withFrontCover view


{-| `Story` is options of `view` argument.

`Story` has label, argument name, and options that have value and label.

    |> addStory
        (Story "msg" [ ( "nothing", Nothing ), ( "click", Just "msg" ) ])

To build `Story`, see [Bibliopola.Story](./Bibliopola-Story).

-}
type alias Story a =
    { label : String
    , options : List ( String, a )
    }


{-| `IntoBook` is building `Book` type.

Use [`intoBook`](#intoBook).

-}
type alias IntoBook msg view =
    { title : String
    , views : List ( List String, view )
    , stories : List ( String, List String )
    , toString : msg -> String
    }


{-| Build [`IntoBook`](#IntoBook)

First argument, `String`, is book title.
Second, `msg -> String`, is for message logger.
Last, `view`, is your `view` function.

    book : Book
    book =
        intoBook "HelloYou" identity view
            |> addStory (Story.build "name" identity [ "spam", "egg", "ham" ])
            |> buildBook

-}
intoBook : String -> (msg -> String) -> view -> IntoBook msg view
intoBook title toString view =
    { title = title
    , toString = toString
    , stories = []
    , views = [ Tuple.pair [] view ]
    }


{-| Turn `IntoBook` to `Book`.

To use `intoBook` and `addStory`, `view` function is filled up with arguments.

This is for elm-ui `Element`.

-}
buildBook : IntoBook msg (Element msg) -> Book
buildBook { title, views, toString, stories } =
    Book.empty title
        |> Book.setPages
            (List.map
                (\( optionLabels, view ) ->
                    ( List.reverse optionLabels |> String.join "/"
                    , Element.map (toString >> LogMsg) view
                    )
                )
                views
                |> Dict.fromList
            )
        |> Book.setStories (List.reverse stories |> List.filterMap storyHelp)


{-| Turn `IntoBook` to `Book`

This is for `Html`.

-}
buildHtmlBook : IntoBook msg (Html msg) -> Book
buildHtmlBook { title, views, toString, stories } =
    buildBook
        { title = title
        , toString = toString
        , stories = stories
        , views = List.map (Tuple.mapSecond Element.html) views
        }


storyHelp : ( String, List String ) -> Maybe ( String, SelectList String )
storyHelp ( label, options ) =
    SelectList.fromList options
        |> Maybe.map (Tuple.pair label)


{-| Add a story to `IntoBook`.
-}
addStory : Story a -> IntoBook msg (a -> view) -> IntoBook msg view
addStory { label, options } { title, views, stories, toString } =
    { title = title
    , toString = toString
    , views =
        List.lift2
            (\( optionLabels, view ) ( optionLabel, option ) ->
                ( optionLabel :: optionLabels, view option )
            )
            views
            options
    , stories = ( label, List.map Tuple.first options ) :: stories
    }
