module Bibliopola
    exposing
        ( Book
        , Program
        , Shelf
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
        , shelfWithoutBooks
        , withFrontCover
        )

{-| UI Catalog for Elm applications built by style-elements inspired by Storybook

[demo](https://miyamoen.github.io/bibliopola/)


# Types

@docs Program, Book, Shelf


## Program

@docs fromBook, fromShelf


# Book

@docs bookWithoutStory, bookWith, bookWith2, bookWith3, bookWith4

@docs withFrontCover


# Shelf

@docs shelfWithoutBooks, shelfWith
@docs addBook, addShelf

-}

import Dict exposing (Dict)
import Element exposing (Element)
import Lazy exposing (lazy)
import Lazy.Tree as Tree
import Lazy.Tree.Zipper as Zipper exposing (Zipper(Zipper))
import List.Extra as List
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
type alias Options a =
    { label : String
    , options :
        ( String, List ( String, a ) )
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
        , stories = Dict.empty
        , options = []
        , optionModeOn = False
        }


{-| -}
bookWith :
    String
    -> (a -> Element style variation msg)
    -> ( String, List ( String, a ) )
    -> Book style variation
bookWith name view ( storyName, stories ) =
    let
        stories_ =
            [ storyName => List.map Tuple.first stories ]
    in
    { name = name
    , state = Close
    , stories = stories_
    , variations =
        List.map
            (Tuple.mapSecond
                (\a -> lazy (\() -> view a |> Element.map (toString >> LogMsg)))
            )
            stories
            |> Dict.fromList
    , form = { storyOn = False, stories = initFormStories stories_ }
    }


{-| -}
bookWith2 :
    String
    -> (a -> b -> Element style variation msg)
    -> ( String, List ( String, a ) )
    -> ( String, List ( String, b ) )
    -> Book style variation
bookWith2 name view ( aStoryName, aStories ) ( bStoryName, bStories ) =
    let
        stories_ =
            [ aStoryName => List.map Tuple.first aStories
            , bStoryName => List.map Tuple.first bStories
            ]
    in
    { name = name
    , state = Close
    , stories = stories_
    , variations =
        List.lift2
            (\( aName, a ) ( bName, b ) ->
                String.join "/" [ aName, bName ]
                    => lazy (\() -> view a b |> Element.map (toString >> LogMsg))
            )
            aStories
            bStories
            |> Dict.fromList
    , form = { storyOn = False, stories = initFormStories stories_ }
    }


{-| -}
bookWith3 :
    String
    -> (a -> b -> c -> Element style variation msg)
    -> ( String, List ( String, a ) )
    -> ( String, List ( String, b ) )
    -> ( String, List ( String, c ) )
    -> Book style variation
bookWith3 name view ( aStoryName, aStories ) ( bStoryName, bStories ) ( cStoryName, cStories ) =
    let
        stories_ =
            [ aStoryName => List.map Tuple.first aStories
            , bStoryName => List.map Tuple.first bStories
            , cStoryName => List.map Tuple.first cStories
            ]
    in
    { name = name
    , state = Close
    , stories = stories_
    , variations =
        List.lift3
            (\( aName, a ) ( bName, b ) ( cName, c ) ->
                String.join "/" [ aName, bName, cName ]
                    => lazy (\() -> view a b c |> Element.map (toString >> LogMsg))
            )
            aStories
            bStories
            cStories
            |> Dict.fromList
    , form = { storyOn = False, stories = initFormStories stories_ }
    }


{-| -}
bookWith4 :
    String
    -> (a -> b -> c -> d -> Element style variation msg)
    -> ( String, List ( String, a ) )
    -> ( String, List ( String, b ) )
    -> ( String, List ( String, c ) )
    -> ( String, List ( String, d ) )
    -> Book style variation
bookWith4 name view ( aStoryName, aStories ) ( bStoryName, bStories ) ( cStoryName, cStories ) ( dStoryName, dStories ) =
    let
        stories_ =
            [ aStoryName => List.map Tuple.first aStories
            , bStoryName => List.map Tuple.first bStories
            , cStoryName => List.map Tuple.first cStories
            , dStoryName => List.map Tuple.first dStories
            ]
    in
    { name = name
    , state = Close
    , stories = stories_
    , variations =
        List.lift4
            (\( aName, a ) ( bName, b ) ( cName, c ) ( dName, d ) ->
                String.join "/" [ aName, bName, cName, dName ]
                    => lazy (\() -> view a b c d |> Element.map (toString >> LogMsg))
            )
            aStories
            bStories
            cStories
            dStories
            |> Dict.fromList
    , form = { storyOn = False, stories = initFormStories stories_ }
    }


{-| -}
withFrontCover :
    Element style variation msg
    -> Book style variation
    -> Book style variation
withFrontCover view viewItem =
    { viewItem
        | variations =
            viewItem.variations
                |> Dict.insert
                    "default"
                    (lazy <| \_ -> Element.map (toString >> LogMsg) view)
    }


initFormStories : List ( String, List String ) -> Dict String String
initFormStories stories =
    stories
        |> List.map (Tuple.mapSecond (List.head >> Maybe.withDefault ""))
        |> Dict.fromList



-- Shelf


{-| -}
shelfWith : Book style variation -> Shelf style variation
shelfWith item =
    Zipper.fromTree <| Tree.singleton item


{-| -}
shelfWithoutBooks : String -> Shelf style variation
shelfWithoutBooks name =
    bookWithoutStory name
        |> shelfWith


{-| -}
addBook : Book s v -> Shelf s v -> Shelf s v
addBook item tree =
    Zipper.insert (Tree.singleton item) tree


{-| -}
addShelf : Shelf s v -> Shelf s v -> Shelf s v
addShelf (Zipper childTree _) tree =
    Zipper.insert childTree tree
