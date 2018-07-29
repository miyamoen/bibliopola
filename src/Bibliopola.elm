module Bibliopola exposing (..)

import Dict
import Element exposing (Element)
import Lazy exposing (lazy)
import Lazy.Tree as Tree
import Lazy.Tree.Zipper as Zipper exposing (Zipper(Zipper))
import List.Extra as List
import Navigation
import Route
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
        }



-- ViewItem


createEmptyViewItem : String -> ViewItem child childVar
createEmptyViewItem name =
    { name = name
    , state = Close
    , stories = []
    , variations = Dict.empty
    }


createViewItem :
    String
    -> (a -> Element child childVar msg)
    -> ( String, List ( String, a ) )
    -> ViewItem child childVar
createViewItem name view ( storyName, stories ) =
    { name = name
    , state = Close
    , stories = [ storyName => List.map Tuple.first stories ]
    , variations =
        List.map
            (Tuple.mapSecond
                (\a -> lazy (\() -> view a |> Element.map (toString >> Print)))
            )
            stories
            |> Dict.fromList
    }


createViewItem2 :
    String
    -> (a -> b -> Element child childVar msg)
    -> ( String, List ( String, a ) )
    -> ( String, List ( String, b ) )
    -> ViewItem child childVar
createViewItem2 name view ( aStoryName, aStories ) ( bStoryName, bStories ) =
    { name = name
    , state = Close
    , stories =
        [ aStoryName => List.map Tuple.first aStories
        , bStoryName => List.map Tuple.first bStories
        ]
    , variations =
        List.lift2
            (\( aName, a ) ( bName, b ) ->
                String.join "/" [ aName, bName ]
                    => lazy (\() -> view a b |> Element.map (toString >> Print))
            )
            aStories
            bStories
            |> Dict.fromList
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



-- ViewTree


createViewTreeFromItem : ViewItem child childVar -> ViewTree child childVar
createViewTreeFromItem item =
    Zipper.fromTree <| Tree.singleton item


createEmptyViewTree : String -> ViewTree child childVar
createEmptyViewTree name =
    { name = name
    , state = Close
    , stories = []
    , variations = Dict.empty
    }
        |> createViewTreeFromItem


insertViewItem : ViewItem s v -> ViewTree s v -> ViewTree s v
insertViewItem item tree =
    Zipper.insert (Tree.singleton item) tree


insertViewTree : ViewTree s v -> ViewTree s v -> ViewTree s v
insertViewTree (Zipper childTree _) tree =
    Zipper.insert childTree tree
