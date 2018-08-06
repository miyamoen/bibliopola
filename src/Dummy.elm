module Dummy exposing (..)

import Bibliopola exposing (createViewItem4, createViewTreeFromItem)
import Dict
import Element exposing (column, text)
import Lazy exposing (lazy)
import Lazy.LList as LList
import Lazy.Tree as Tree exposing (Tree(Tree))
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import Route
import SelectList
import Types exposing (..)


model : Model s v
model =
    { styles = []
    , views = views
    , route = Route.View [] <| Dict.fromList []
    , panel =
        SelectList.fromLists []
            StoryPanel
            [ StoryPanel, StoryPanel, StoryPanel, StoryPanel, StoryPanel ]
    }


views : ViewTree s v
views =
    Zipper.fromTree <|
        Tree (item Open "root") <|
            LList.fromList
                [ Tree.singleton (item Open "ham")
                , Tree (emptyItem Close "egg") <|
                    LList.fromList
                        [ Tree.singleton (item Close "boiled")
                        , Tree.singleton (item Close "fried")
                        , Tree.singleton (item Close "scrambled")
                        ]
                , Tree (item Open "spam") <|
                    LList.fromList
                        [ Tree (emptyItem Open "spamspam") <|
                            LList.fromList [ Tree.singleton (item Close "spamspamspam") ]
                        ]
                ]


item : State -> String -> ViewItem s v
item state name =
    { name = name
    , state = state
    , stories = []
    , variations =
        Dict.fromList
            [ "default" => lazy (\_ -> text <| name ++ " view") ]
    , form = { storyOn = False, stories = Dict.empty }
    }


emptyItem : State -> String -> ViewItem s v
emptyItem state name =
    { name = name
    , state = state
    , stories = []
    , variations = Dict.empty
    , form = { storyOn = False, stories = Dict.empty }
    }


storyTree : ViewTree s v
storyTree =
    createViewItem4 "4Stories"
        (\a b c d -> text <| String.join ", " [ a, b, c, d ])
        ( "aStory", [ "aStory1" => "aStory1", "aStory2" => "aStory2", "aStory3" => "aStory3", "aStory4" => "aStory4", "aStory5" => "aStory5" ] )
        ( "bStory", [ "bStory1" => "bStory1", "bStory2" => "bStory2", "bStory3" => "bStory3", "bStory4" => "bStory4", "bStory5" => "bStory5" ] )
        ( "cStory", [ "cStory1" => "cStory1", "cStory2" => "cStory2", "cStory3" => "cStory3", "cStory4" => "cStory4", "cStory5" => "cStory5" ] )
        ( "dStory", [ "dStory1" => "dStory1", "dStory2" => "dStory2", "dStory3" => "dStory3", "dStory4" => "dStory4", "dStory5" => "dStory5" ] )
        |> createViewTreeFromItem
