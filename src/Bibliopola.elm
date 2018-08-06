module Bibliopola exposing (..)

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


createMain : Model child childVar -> MyProgram child childVar
createMain model =
    Navigation.program (Route.route >> SetRoute)
        { view = view
        , init =
            \location ->
                ( { model | route = Route.route location }, Cmd.none )
        , update = update
        , subscriptions = always Sub.none
        }


createMainFromViewItem :
    List (Style child childVar)
    -> ViewItem child childVar
    -> MyProgram child childVar
createMainFromViewItem styles item =
    createMainFromViewTree styles <| createViewTreeFromItem item


createMainFromViewTree :
    List (Style child childVar)
    -> ViewTree child childVar
    -> MyProgram child childVar
createMainFromViewTree styles tree =
    createMain
        { route = Route.View [] <| Dict.fromList []
        , views = tree
        , styles = styles
        , panel = SelectList.singleton StoryPanel
        }



-- ViewItem


createEmptyViewItem : String -> ViewItem child childVar
createEmptyViewItem name =
    { name = name
    , state = Close
    , stories = []
    , variations = Dict.empty
    , form = { storyOn = False, stories = Dict.empty }
    }


createViewItem :
    String
    -> (a -> Element child childVar msg)
    -> ( String, List ( String, a ) )
    -> ViewItem child childVar
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
                (\a -> lazy (\() -> view a |> Element.map (toString >> Print)))
            )
            stories
            |> Dict.fromList
    , form = { storyOn = False, stories = initFormStories stories_ }
    }


createViewItem2 :
    String
    -> (a -> b -> Element child childVar msg)
    -> ( String, List ( String, a ) )
    -> ( String, List ( String, b ) )
    -> ViewItem child childVar
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
                    => lazy (\() -> view a b |> Element.map (toString >> Print))
            )
            aStories
            bStories
            |> Dict.fromList
    , form = { storyOn = False, stories = initFormStories stories_ }
    }


createViewItem3 :
    String
    -> (a -> b -> c -> Element child childVar msg)
    -> ( String, List ( String, a ) )
    -> ( String, List ( String, b ) )
    -> ( String, List ( String, c ) )
    -> ViewItem child childVar
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
                    => lazy (\() -> view a b c |> Element.map (toString >> Print))
            )
            aStories
            bStories
            cStories
            |> Dict.fromList
    , form = { storyOn = False, stories = initFormStories stories_ }
    }


createViewItem4 :
    String
    -> (a -> b -> c -> d -> Element child childVar msg)
    -> ( String, List ( String, a ) )
    -> ( String, List ( String, b ) )
    -> ( String, List ( String, c ) )
    -> ( String, List ( String, d ) )
    -> ViewItem child childVar
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
                    => lazy (\() -> view a b c d |> Element.map (toString >> Print))
            )
            aStories
            bStories
            cStories
            dStories
            |> Dict.fromList
    , form = { storyOn = False, stories = initFormStories stories_ }
    }


withDefaultVariation :
    Element child childVar msg
    -> ViewItem child childVar
    -> ViewItem child childVar
withDefaultVariation view viewItem =
    { viewItem
        | variations =
            viewItem.variations
                |> Dict.insert
                    "default"
                    (lazy <| \_ -> Element.map (toString >> Print) view)
    }


initFormStories : List ( String, List String ) -> Dict String String
initFormStories stories =
    stories
        |> List.map (Tuple.mapSecond (List.head >> Maybe.withDefault ""))
        |> Dict.fromList



-- ViewTree


createViewTreeFromItem : ViewItem child childVar -> ViewTree child childVar
createViewTreeFromItem item =
    Zipper.fromTree <| Tree.singleton item


createEmptyViewTree : String -> ViewTree child childVar
createEmptyViewTree name =
    createEmptyViewItem name
        |> createViewTreeFromItem


insertViewItem : ViewItem s v -> ViewTree s v -> ViewTree s v
insertViewItem item tree =
    Zipper.insert (Tree.singleton item) tree


insertViewTree : ViewTree s v -> ViewTree s v -> ViewTree s v
insertViewTree (Zipper childTree _) tree =
    Zipper.insert childTree tree
