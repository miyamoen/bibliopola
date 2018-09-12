module Bibliopola exposing
    ( Program, Book, Shelf
    , fromBook, fromShelf
    , Story
    , withFrontCover
    , emptyShelf, shelfWith
    , addBook, addShelf
    , IntoBook, addStory, bookWithFrontCover, buildBook, intoBook
    )

{-| UI Catalog for Elm applications built by style-elements inspired by Storybook

[demo](https://miyamoen.github.io/bibliopola/)


# Types

@docs Program, Book, Shelf


## Program

@docs fromBook, fromShelf


# Book

@docs Story

@docs emptyBook, bookWith, bookWith2, bookWith3, bookWith4

@docs withFrontCover


# Shelf

@docs emptyShelf, shelfWith
@docs addBook, addShelf

-}

import Browser
import Dict exposing (Dict)
import Element exposing (Element)
import Html
import List.Extra as List exposing (lift2)
import Maybe.Extra as Maybe
import Model.Book as Book
import Route
import SelectList exposing (SelectList)
import Tree
import Tree.Zipper as Zipper exposing (Zipper(..))
import Types exposing (..)
import Update exposing (..)
import View exposing (view)


{-| -}
type alias Program =
    Platform.Program () Model Msg


{-| -}
type alias Book =
    Types.Book


{-| -}
type alias Shelf =
    Types.Shelf



-- main Program


{-| -}
fromBook : Book -> Program
fromBook book =
    fromShelf <| shelfWith book


{-| -}
fromShelf : Shelf -> Program
fromShelf shelf =
    Browser.application
        { view = \model -> { title = "Bibliopola", body = [ view model ] }
        , init = init shelf
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = onUrlRequest
        , onUrlChange = onUrlChange
        }



-- Shelf


{-| -}
shelfWith : Book -> Shelf
shelfWith book =
    Shelf <| Zipper.fromTree <| Tree.singleton book


{-| -}
emptyShelf : String -> Shelf
emptyShelf name =
    Book.empty name
        |> shelfWith


{-| -}
addBook : Book -> Shelf -> Shelf
addBook book (Shelf zipper) =
    Shelf <| Zipper.insert (Tree.singleton book) zipper


{-| -}
addShelf : Shelf -> Shelf -> Shelf
addShelf (Shelf (Zipper childTree _)) (Shelf zipper) =
    Shelf <| Zipper.insert childTree zipper



-- Book


{-| -}
withFrontCover : Element String -> Book -> Book
withFrontCover view book =
    Book.withFrontCover view book



-- Build Book


bookWithFrontCover : String -> Element String -> Book
bookWithFrontCover title view =
    Book.empty title
        |> Book.withFrontCover view


{-| -}
type alias Story a =
    { label : String
    , options : List ( String, a )
    }


{-| -}
type alias IntoBook msg view =
    { title : String
    , views : List ( List String, view )
    , stories : List ( String, List String )
    , toString : msg -> String
    }


{-| -}
intoBook : String -> (msg -> String) -> view -> IntoBook msg view
intoBook title toString view =
    { title = title
    , toString = toString
    , stories = []
    , views = [ Tuple.pair [] view ]
    }


{-| -}
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


storyHelp : ( String, List String ) -> Maybe ( String, SelectList String )
storyHelp ( label, options ) =
    SelectList.fromList options
        |> Maybe.map (Tuple.pair label)


{-| -}
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
