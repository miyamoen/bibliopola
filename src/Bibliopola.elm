module Bibliopola exposing
    ( Program, Book, Shelf
    , fromBook, fromShelf
    , Story
    , emptyBook
    , withFrontCover
    , shelfWithoutBook, shelfWith
    , addBook, addShelf
    , addStory1
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

@docs shelfWithoutBook, shelfWith
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



-- import Update exposing (update)


{-| -}
type alias Program =
    Platform.Program () Model Msg


{-| -}
type alias Book =
    Types.Book


{-| -}
type alias Shelf =
    Types.Shelf


{-| -}
type alias Story a =
    { label : String
    , options : List ( String, a )
    }


{-| -}
fromBook : Book -> Program
fromBook book =
    fromShelf <| shelfWith book


{-| -}
fromShelf : Shelf -> Program
fromShelf shelf =
    Browser.application
        { view = \_ -> { title = "Bibliopola", body = [ Html.text "Compiled!" ] }
        , init = init shelf
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = onUrlRequest
        , onUrlChange = onUrlChange
        }



-- Book


{-| -}
emptyBook : String -> Book
emptyBook title =
    Book.empty title


convertStory : Story a -> ( String, List String )
convertStory story =
    Tuple.pair story.label <| List.map Tuple.first story.options


convertToSelectList :
    List ( String, List String )
    -> List ( String, SelectList String )
convertToSelectList list =
    List.map
        (\( label, options ) ->
            SelectList.fromList options
                |> Maybe.map (Tuple.pair label)
        )
        list
        |> Maybe.combine
        |> Maybe.withDefault []


type alias ToString msg =
    msg -> String


{-| -}
type alias IntoBook1 msg a1 =
    { title : String
    , views : List ( List String, a1 -> Element msg )
    , toString : ToString msg
    }


type alias IntoBook msg view =
    { title : String
    , views : List ( List String, view )
    , toString : ToString msg
    }


intoBook : String -> ToString msg -> view -> IntoBook msg view
intoBook title toString view =
    { title = title
    , toString = toString
    , views = [ Tuple.pair [] view ]
    }


intoBook1 : String -> ToString msg -> (a1 -> Element msg) -> IntoBook1 msg a1
intoBook1 title toString view =
    { title = title
    , toString = toString
    , views = [ Tuple.pair [] view ]
    }


intoBook2 :
    String
    -> ToString msg
    -> (a1 -> a2 -> Element msg)
    -> IntoBook2 msg a1 a2
intoBook2 title toString view =
    { title = title
    , toString = toString
    , views = [ Tuple.pair [] view ]
    }


{-| -}
addStory1 : Story a1 -> IntoBook1 msg a1 -> Book
addStory1 { label, options } { title, views, toString } =
    Book.empty title
        |> Book.setPages
            (List.lift2
                (\( optionLabels, view ) ( optionLabel, option ) ->
                    ( optionLabel
                        :: optionLabels
                        |> List.reverse
                        |> String.join "/"
                    , view option
                        |> Element.map (toString >> LogMsg)
                    )
                )
                views
                options
                |> Dict.fromList
            )


{-| -}
type alias IntoBook2 msg a1 a2 =
    { title : String
    , views : List ( List String, a1 -> a2 -> Element msg )
    , toString : msg -> String
    }


{-| -}
addStory2 : Story a1 -> IntoBook2 msg a1 a2 -> IntoBook1 msg a2
addStory2 { label, options } { title, views, toString } =
    { title = title
    , toString = toString
    , views =
        List.lift2
            (\( optionLabels, view ) ( optionLabel, option ) ->
                ( optionLabel :: optionLabels, view option )
            )
            views
            options
    }


{-| -}
withFrontCover :
    Element msg
    -> Book
    -> Book
withFrontCover view book =
    Book.withFrontCover view book



-- Shelf


{-| -}
shelfWith : Book -> Shelf
shelfWith book =
    Shelf <| Zipper.fromTree <| Tree.singleton book


{-| -}
shelfWithoutBook : String -> Shelf
shelfWithoutBook name =
    emptyBook name
        |> shelfWith


{-| -}
addBook : Book -> Shelf -> Shelf
addBook book (Shelf zipper) =
    Shelf <| Zipper.insert (Tree.singleton book) zipper


{-| -}
addShelf : Shelf -> Shelf -> Shelf
addShelf (Shelf (Zipper childTree _)) (Shelf zipper) =
    Shelf <| Zipper.insert childTree zipper
