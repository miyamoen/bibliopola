module Bibliopola
    exposing
        ( Book
        , Program
        , Shelf
        , createEmptyViewItem
        , createEmptyViewTree
        , createProgramFromViewItem
        , createProgramFromViewTree
        , createViewItem
        , createViewItem2
        , createViewItem3
        , createViewItem4
        , createViewTreeFromItem
        , insertViewItem
        , insertViewTree
        , withDefaultVariation
        )

{-| UI Catalog for Elm applications built by style-elements inspired by Storybook

[demo](https://miyamoen.github.io/bibliopola/)


# Types

@docs Program, Book, Shelf


## Program

@docs createProgramFromViewItem, createProgramFromViewTree


# Book

@docs createEmptyViewItem, createViewItem, createViewItem2, createViewItem3, createViewItem4

@docs withDefaultVariation


# Shelf

@docs createEmptyViewTree, createViewTreeFromItem
@docs insertViewItem, insertViewTree

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
createMain : Model style variation -> BibliopolaProgram style variation
createMain model =
    Navigation.program (Route.route >> SetRoute)
        { view = view
        , init =
            \location ->
                ( { model | route = Route.route location }, Cmd.none )
        , update = update
        , subscriptions = always Sub.none
        }


{-| -}
createProgramFromViewItem :
    List (Style style variation)
    -> Book style variation
    -> BibliopolaProgram style variation
createProgramFromViewItem styles item =
    createProgramFromViewTree styles <| createViewTreeFromItem item


{-| -}
createProgramFromViewTree :
    List (Style style variation)
    -> Shelf style variation
    -> BibliopolaProgram style variation
createProgramFromViewTree styles tree =
    createMain
        { route = Route.View [] <| Dict.fromList []
        , views = tree
        , styles = styles
        , panel =
            SelectList.fromLists []
                StoryPanel
                [ MsgLoggerPanel, AuthorPanel ]
        , logs = []
        }



-- Book


{-| -}
createEmptyViewItem : String -> Book style variation
createEmptyViewItem name =
    { name = name
    , state = Close
    , stories = []
    , variations = Dict.empty
    , form = { storyOn = False, stories = Dict.empty }
    }


{-| -}
createViewItem :
    String
    -> (a -> Element style variation msg)
    -> ( String, List ( String, a ) )
    -> Book style variation
createViewItem name view ( storyName, stories ) =
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
createViewItem2 :
    String
    -> (a -> b -> Element style variation msg)
    -> ( String, List ( String, a ) )
    -> ( String, List ( String, b ) )
    -> Book style variation
createViewItem2 name view ( aStoryName, aStories ) ( bStoryName, bStories ) =
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
createViewItem3 :
    String
    -> (a -> b -> c -> Element style variation msg)
    -> ( String, List ( String, a ) )
    -> ( String, List ( String, b ) )
    -> ( String, List ( String, c ) )
    -> Book style variation
createViewItem3 name view ( aStoryName, aStories ) ( bStoryName, bStories ) ( cStoryName, cStories ) =
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
createViewItem4 :
    String
    -> (a -> b -> c -> d -> Element style variation msg)
    -> ( String, List ( String, a ) )
    -> ( String, List ( String, b ) )
    -> ( String, List ( String, c ) )
    -> ( String, List ( String, d ) )
    -> Book style variation
createViewItem4 name view ( aStoryName, aStories ) ( bStoryName, bStories ) ( cStoryName, cStories ) ( dStoryName, dStories ) =
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
withDefaultVariation :
    Element style variation msg
    -> Book style variation
    -> Book style variation
withDefaultVariation view viewItem =
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
createViewTreeFromItem : Book style variation -> Shelf style variation
createViewTreeFromItem item =
    Zipper.fromTree <| Tree.singleton item


{-| -}
createEmptyViewTree : String -> Shelf style variation
createEmptyViewTree name =
    createEmptyViewItem name
        |> createViewTreeFromItem


{-| -}
insertViewItem : Book s v -> Shelf s v -> Shelf s v
insertViewItem item tree =
    Zipper.insert (Tree.singleton item) tree


{-| -}
insertViewTree : Shelf s v -> Shelf s v -> Shelf s v
insertViewTree (Zipper childTree _) tree =
    Zipper.insert childTree tree
