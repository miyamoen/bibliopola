module Bibliopola
    exposing
        ( Book
        , Program
        , Shelf
        , Story
        , addBook
        , addShelf
        , bookWith
        , bookWith2
        , bookWith3
        , bookWith4
        , bookWithoutStory
        , fromBook
        , fromShelf
        , shelfWith
        , shelfWithoutBook
        , withFrontCover
        )

{-| UI Catalog for Elm applications built by style-elements inspired by Storybook

[demo](https://miyamoen.github.io/bibliopola/)


# Types

@docs Program, Book, Shelf


## Program

@docs fromBook, fromShelf


# Book

@docs Story

@docs bookWithoutStory, bookWith, bookWith2, bookWith3, bookWith4

@docs withFrontCover


# Shelf

@docs shelfWithoutBook, shelfWith
@docs addBook, addShelf

-}

import Dict exposing (Dict)
import Element exposing (Element)
import Lazy exposing (lazy)
import Lazy.Tree as Tree
import Lazy.Tree.Zipper as Zipper exposing (Zipper(Zipper))
import List.Extra as List
import Maybe.Extra as Maybe
import Model.Book as Book
import Navigation
import Route
import SelectList exposing (SelectList)
import Style exposing (Style)
import Types exposing (..)
import Update exposing (update)
import View exposing (view)


{-| -}
type alias Program style variation =
    Types.Program style variation


{-| -}
type alias Book style variation =
    Types.Book style variation


{-| -}
type alias Shelf style variation =
    Types.Shelf style variation


{-| -}
type alias Story a =
    { label : String
    , options : List ( String, a )
    }


{-| -}
fromModel : Model style variation -> Program style variation
fromModel model =
    Navigation.program (Route.route >> SetRoute)
        { view = view
        , init =
            \location ->
                ( { model | route = Route.route location }, Cmd.none )
        , update = update
        , subscriptions = always Sub.none
        }


{-| -}
fromBook :
    List (Style style variation)
    -> Book style variation
    -> Program style variation
fromBook styles book =
    fromShelf styles <| shelfWith book


{-| -}
fromShelf :
    List (Style style variation)
    -> Shelf style variation
    -> Program style variation
fromShelf styles shelf =
    fromModel
        { route = Route.View [] <| Dict.fromList []
        , shelf = shelf
        , styles = styles
        , panel =
            SelectList.fromLists []
                StoryPanel
                [ MsgLoggerPanel, AuthorPanel ]
        , logs = []
        }



-- Book


{-| -}
bookWithoutStory : String -> Book style variation
bookWithoutStory name =
    Book
        { name = name
        , state = Close
        , pages = Dict.empty
        , stories = []
        , storyModeOn = False
        }


convertStory : Story a -> ( String, List String )
convertStory story =
    story.label => List.map Tuple.first story.options


convertToSelectList :
    List ( String, List String )
    -> List ( String, SelectList String )
convertToSelectList list =
    List.map
        (\( label, options ) ->
            SelectList.fromList options
                |> Maybe.map (\options -> label => options)
        )
        list
        |> Maybe.combine
        |> Maybe.withDefault []


{-| -}
bookWith :
    String
    -> (a -> Element style variation msg)
    -> Story a
    -> Book style variation
bookWith name view story =
    let
        stories =
            convertToSelectList [ convertStory story ]

        lazyView a =
            lazy (\() -> view a)
                |> Lazy.map (Element.map (toString >> LogMsg))

        pages =
            List.map (Tuple.mapSecond lazyView) story.options
                |> Dict.fromList
    in
    bookWithoutStory name
        |> Book.setStories stories
        |> Book.setPages pages


{-| -}
bookWith2 :
    String
    -> (a -> b -> Element style variation msg)
    -> Story a
    -> Story b
    -> Book style variation
bookWith2 name view storyA storyB =
    let
        stories =
            convertToSelectList
                [ convertStory storyA
                , convertStory storyB
                ]

        lazyView a b =
            lazy (\() -> view a b)
                |> Lazy.map (Element.map (toString >> LogMsg))

        pages =
            List.lift2
                (\( nameA, a ) ( nameB, b ) ->
                    String.join "/" [ nameA, nameB ] => lazyView a b
                )
                storyA.options
                storyB.options
                |> Dict.fromList
    in
    bookWithoutStory name
        |> Book.setStories stories
        |> Book.setPages pages


{-| -}
bookWith3 :
    String
    -> (a -> b -> c -> Element style variation msg)
    -> Story a
    -> Story b
    -> Story c
    -> Book style variation
bookWith3 name view storyA storyB storyC =
    let
        stories =
            convertToSelectList
                [ convertStory storyA
                , convertStory storyB
                , convertStory storyC
                ]

        lazyView a b c =
            lazy (\() -> view a b c)
                |> Lazy.map (Element.map (toString >> LogMsg))

        pages =
            List.lift3
                (\( nameA, a ) ( nameB, b ) ( nameC, c ) ->
                    String.join "/" [ nameA, nameB, nameC ]
                        => lazyView a b c
                )
                storyA.options
                storyB.options
                storyC.options
                |> Dict.fromList
    in
    bookWithoutStory name
        |> Book.setStories stories
        |> Book.setPages pages


{-| -}
bookWith4 :
    String
    -> (a -> b -> c -> d -> Element style variation msg)
    -> Story a
    -> Story b
    -> Story c
    -> Story d
    -> Book style variation
bookWith4 name view storyA storyB storyC storyD =
    let
        stories =
            convertToSelectList
                [ convertStory storyA
                , convertStory storyB
                , convertStory storyC
                , convertStory storyD
                ]

        lazyView a b c d =
            lazy (\() -> view a b c d)
                |> Lazy.map (Element.map (toString >> LogMsg))

        pages =
            List.lift4
                (\( nameA, a ) ( nameB, b ) ( nameC, c ) ( nameD, d ) ->
                    String.join "/" [ nameA, nameB, nameC, nameD ]
                        => lazyView a b c d
                )
                storyA.options
                storyB.options
                storyC.options
                storyD.options
                |> Dict.fromList
    in
    bookWithoutStory name
        |> Book.setStories stories
        |> Book.setPages pages


{-| -}
withFrontCover :
    Element style variation msg
    -> Book style variation
    -> Book style variation
withFrontCover view book =
    Book.withFrontCover view book



-- Shelf


{-| -}
shelfWith : Book style variation -> Shelf style variation
shelfWith book =
    Shelf <| Zipper.fromTree <| Tree.singleton book


{-| -}
shelfWithoutBook : String -> Shelf style variation
shelfWithoutBook name =
    bookWithoutStory name
        |> shelfWith


{-| -}
addBook : Book s v -> Shelf s v -> Shelf s v
addBook book (Shelf zipper) =
    Shelf <| Zipper.insert (Tree.singleton book) zipper


{-| -}
addShelf : Shelf s v -> Shelf s v -> Shelf s v
addShelf (Shelf (Zipper childTree _)) (Shelf zipper) =
    Shelf <| Zipper.insert childTree zipper
